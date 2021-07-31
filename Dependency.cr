module ISM

  class Dependency

    property name = ISM::Default::Dependency::Name
    property version = ISM::Default::Dependency::Version
    property options = ISM::Default::Dependency::Options

    def initialize( name = ISM::Default::Dependency::Name,
                    version = ISM::Default::Dependency::Version,
                    options = ISM::Default::Dependency::Options)
                    @name = name
                    @version = version
                    @options = option
  end

end
