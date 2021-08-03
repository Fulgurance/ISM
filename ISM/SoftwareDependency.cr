module ISM

  class SoftwareDependency

    property name = ISM::Default::SoftwareDependency::Name
    property version = ISM::Default::SoftwareDependency::Version
    property options = ISM::Default::SoftwareDependency::Options

    def initialize( name = ISM::Default::SoftwareDependency::Name,
                    version = ISM::Default::SoftwareDependency::Version,
                    options = ISM::Default::SoftwareDependency::Options)
                    @name = name
                    @version = version
                    @options = option
    end

  end

end