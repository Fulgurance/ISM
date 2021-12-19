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
        name : String,
        version : String,
        architectures : Array(String),
        description : String,
        website : String,
        downloadLinks : Array(String),
        signatureLinks : Array(String),
        shasumLinks : Array(String),
        dependencies : Array(Dependency),
        options : Array(Option) do
        include JSON::Serializable
    end

    property name = ISM::Default::SoftwareInformation::Name
    property version = ISM::Default::SoftwareInformation::Version
    property architectures = ISM::Default::SoftwareInformation::Architectures
    property description = ISM::Default::SoftwareInformation::Description
    property website = ISM::Default::SoftwareInformation::Website
    property downloadLinks = ISM::Default::SoftwareInformation::DownloadLinks
    property signatureLinks = ISM::Default::SoftwareInformation::SignatureLinks
    property shasumLinks = ISM::Default::SoftwareInformation::ShasumLinks
    property dependencies = ISM::Default::SoftwareInformation::Dependencies
    property options = ISM::Default::SoftwareInformation::Options

    def initialize( name = ISM::Default::SoftwareInformation::Name,
                    version = ISM::Default::SoftwareInformation::Version,
                    architectures = ISM::Default::SoftwareInformation::Architectures,
                    description = ISM::Default::SoftwareInformation::Description,
                    website = ISM::Default::SoftwareInformation::Website,
                    downloadLinks = ISM::Default::SoftwareInformation::DownloadLinks,
                    signatureLinks = ISM::Default::SoftwareInformation::SignatureLinks,
                    shasumLinks = ISM::Default::SoftwareInformation::ShasumLinks,
                    dependencies = ISM::Default::SoftwareInformation::Dependencies,
                    options = ISM::Default::SoftwareInformation::Options)

                    @name = name
                    @version = version
                    @architectures = architectures
                    @description = description
                    @website = website
                    @downloadLinks = downloadLinks
                    @signatureLinks = signatureLinks
                    @shasumLinks = shasumLinks
                    @dependencies = dependencies
                    @options = options
    end

    def loadInformationFile(loadInformationFilePath = ISM::Default::Filename::Information)
      information = Information.from_json(File.read(loadInformationFilePath))

      @name = information.name
      @version = information.version
      @architectures = information.architectures
      @description = information.description
      @website = information.website
      @downloadLinks = information.downloadLinks
      @signatureLinks = information.signatureLinks
      @shasumLinks = information.shasumLinks

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
          @options.push(option)
      end
    
    end

    def writeInformationFile(writeInformationFilePath = ISM::Default::Filename::Information)
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

        information = Information.new(  @name,
                                        @version,
                                        @architectures,
                                        @description,
                                        @website,
                                        @downloadLinks,
                                        @signatureLinks,
                                        @shasumLinks,
                                        dependencies,
                                        options)

        file = File.open(writeInformationFilePath,"w")
        information.to_json(file)
        file.close
    end

    def versionName
        return @name+"-"+@version
    end

  end

end
