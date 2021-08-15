module ISM

  class SoftwareInformation

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

  end

end
