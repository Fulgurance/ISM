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
    property architectures = ISM::Default::SoftwareInformation::Architectures
    property description = ISM::Default::SoftwareInformation::Description
    property website = ISM::Default::SoftwareInformation::Website
    property downloadLinks = ISM::Default::SoftwareInformation::DownloadLinks
    property signatureLinks = ISM::Default::SoftwareInformation::SignatureLinks
    property shasumLinks = ISM::Default::SoftwareInformation::ShasumLinks
    property dependencies = ISM::Default::SoftwareInformation::Dependencies
    property options = ISM::Default::SoftwareInformation::Options

    def initialize( name = ISM::Default::SoftwareInformation::Name,
                    architectures = ISM::Default::SoftwareInformation::Architectures,
                    description = ISM::Default::SoftwareInformation::Description,
                    website = ISM::Default::SoftwareInformation::Website,
                    downloadLinks = ISM::Default::SoftwareInformation::DownloadLinks,
                    signatureLinks = ISM::Default::SoftwareInformation::SignatureLinks,
                    shasumLinks = ISM::Default::SoftwareInformation::ShasumLinks,
                    dependencies = ISM::Default::SoftwareInformation::Dependencies,
                    options = ISM::Default::SoftwareInformation::Options)

                    @name = name
                    @architectures = architectures
                    @description = description
                    @website = website
                    @downloadLinks = downloadLinks
                    @signatureLinks = signatureLinks
                    @shasumLinks = shasumLinks
                    @dependencies = dependencies
                    @options = options
    end

    def loadInformationFile(informationFilePath = ISM::Default::Software::InformationFilePath)
      information = Information.from_json(File.read(informationFilePath))

      @name = information.name
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

  end

end
