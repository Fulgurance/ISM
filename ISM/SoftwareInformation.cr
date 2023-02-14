module ISM

  class SoftwareInformation

    record Option,
        name : String,
        description : String,
        active : Bool,
        dependencies : Array(Dependency) do
        include JSON::Serializable
    end
    
    record Dependency,
        name : String,
        version : String,
        options : Array(String) do
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
        md5sums : Array(String),
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
    property md5sums : Array(String)
    property patchesLinks : Array(String)
    property options : Array(ISM::SoftwareOption)
    property installedFiles : Array(String)
    setter dependencies : Array(ISM::SoftwareDependency)

    def initialize
        @port = String.new
        @name = String.new
        @version = String.new
        @architectures = Array(String).new
        @description = String.new
        @website = String.new
        @downloadLinks = Array(String).new
        @md5sums = Array(String).new
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
      @md5sums = information.md5sums
      @patchesLinks = information.patchesLinks
      @installedFiles = information.installedFiles

      information.dependencies.each do |data|
          dependency = ISM::SoftwareDependency.new
          dependency.name = data.name
          dependency.version = data.version
          dependency.options = data.options
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
        dependenciesArray = Array(Dependency).new
        @dependencies.each do |data|
            dependenciesArray.push(Dependency.new(data.name,data.version,data.options))
        end

        optionsArray = Array(Option).new
        optionsDependenciesArray = Array(Dependency).new
        @options.each do |data|
            data.dependencies.each do |dependencyData|
                dependency = Dependency.new(dependencyData.name,dependencyData.version,dependencyData.options)
                optionsDependenciesArray.push(dependency)
            end

            option = Option.new(data.name,data.description,data.active,optionsDependenciesArray)
            optionsArray.push(option)
            optionsDependenciesArray.clear
        end

        information = Information.new(  @port,
                                        @name,
                                        @version,
                                        @architectures,
                                        @description,
                                        @website,
                                        @downloadLinks,
                                        @md5sums,
                                        @patchesLinks,
                                        @installedFiles,
                                        dependenciesArray,
                                        optionsArray)

        file = File.open(writeInformationFilePath,"w")
        information.to_json(file)
        file.close
    end

    def versionName
        return @name+"-"+@version
    end

    def builtSoftwareDirectoryPath
        return "#{ISM::Default::Path::BuiltSoftwaresDirectory}#{@port}/#{@name}/#{@version}/"
    end

    def dependencies : Array(ISM::SoftwareDependency)
        dependenciesArray = Array(ISM::SoftwareDependency).new

        @options.each do |option|
            dependenciesArray = dependenciesArray+option.dependencies
        end

        return @dependencies+dependenciesArray
    end

    def toSoftwareDependency : ISM::SoftwareDependency
        softwareDependency = ISM::SoftwareDependency.new

        softwareDependency.name = @name
        softwareDependency.version = @version

        @options.each do |option|
            if option.active
                softwareDependency.options << option.name
            end
        end

        return softwareDependency
    end

    def == (other : ISM::SoftwareInformation) : Bool
        return @name == other.name &&
            @version == other.version &&
            @options == other.options
    end

  end

end
