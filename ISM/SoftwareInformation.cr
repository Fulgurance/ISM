module ISM

  class SoftwareInformation

    record Option,
        name : String,
        description : String,
        active : Bool do
        include JSON::Serializable
    end
    
    record Dependency,
        name : String,
        version : String,
        options : Array(Option) do
        include JSON::Serializable
    end
    
    record Information,
        port : String,
        name : String,
        version : String,
        architectures : Array(String),
        description : String,
        website : String,
        downloadLinks : Array(String),
        signatureLinks : Array(String),
        shasumLinks : Array(String),
        patchesLinks : Array(String),
        installedFiles : Array(String),
        dependencies : Array(Dependency),
        options : Array(Option) do
        include JSON::Serializable
    end

    property port : String
    property name : String
    property version : String
    property architectures : Array(String)
    property description : String
    property website : String
    property downloadLinks : Array(String)
    property signatureLinks : Array(String)
    property shasumLinks : Array(String)
    property patchesLinks : Array(String)
    property dependencies : Array(ISM::SoftwareDependency)
    property options : Array(ISM::SoftwareOption)
    property installedFiles : Array(String)

    def initialize
        @port = String.new
        @name = String.new
        @version = String.new
        @architectures = Array(String).new
        @description = String.new
        @website = String.new
        @downloadLinks = Array(String).new
        @signatureLinks = Array(String).new
        @shasumLinks = Array(String).new
        @patchesLinks = Array(String).new
        @installedFiles = Array(String).new
        @dependencies = Array(ISM::SoftwareDependency).new
        @options = Array(ISM::SoftwareOption).new
    end

    def loadInformationFile(loadInformationFilePath : String)
      information = Information.from_json(File.read(loadInformationFilePath))

      @port = information.port
      @name = information.name
      @version = information.version
      @architectures = information.architectures
      @description = information.description
      @website = information.website
      @downloadLinks = information.downloadLinks
      @signatureLinks = information.signatureLinks
      @shasumLinks = information.shasumLinks
      @patchesLinks = information.patchesLinks
      @installedFiles = information.installedFiles

      information.dependencies.each do |data|
          dependency = ISM::SoftwareDependency.new
          dependency.name = data.name
          dependency.version = data.version
          data.options.each do |entry|
              option = ISM::SoftwareOption.new
              option.name = entry.name
              option.description = entry.description
              option.active = entry.active
              dependency.options.push(option)
          end
          @dependencies.push(dependency)
      end

      information.options.each do |data|
          option = ISM::SoftwareOption.new
          option.name = data.name
          option.description = data.description
          option.active = data.active
          @options.push(option)
      end

    end

    def writeInformationFile(writeInformationFilePath : String)
        dependencies = Array(Dependency).new
        @dependencies.each do |data|
            options = Array(Option).new
            data.options.each do |entry|
                option = Option.new(entry.name,entry.description,entry.active)
                options.push(option)
            end
            dependency = Dependency.new(data.name,data.version,options)
            dependencies.push(dependency)
        end

        options = Array(Option).new
        @options.each do |data|
            option = Option.new(data.name,data.description,data.active)
            options.push(option)
        end

        information = Information.new(  @port,
                                        @name,
                                        @version,
                                        @architectures,
                                        @description,
                                        @website,
                                        @downloadLinks,
                                        @signatureLinks,
                                        @shasumLinks,
                                        @patchesLinks,
                                        @installedFiles,
                                        dependencies,
                                        options)

        file = File.open(writeInformationFilePath,"w")
        information.to_json(file)
        file.close
    end

    def versionName
        return @name+"-"+@version
    end

    def builtSoftwareDirectoryPath
        return "#{ISM::Default::Path::BuiltSoftwaresDirectory}#{@port}/#{@name}/#{@version}"
    end

    def toSoftwareDependency : ISM::SoftwareDependency
        softwareDependency = ISM::SoftwareDependency.new

        softwareDependency.name = @name
        softwareDependency.version = @version
        softwareDependency.options = @options

        return softwareDependency
    end

    def == (other : ISM::SoftwareInformation) : Bool
        return @name == other.name && @version == other.version && @options == other.options
    end

  end

end
