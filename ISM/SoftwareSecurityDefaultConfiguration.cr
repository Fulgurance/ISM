module ISM

    class SoftwareSecurityDefaultConfiguration

        def_clone

        include JSON::Serializable

        property fileUser : String
        property fileGroup : String
        property fileMode : String
        property directoryUser : String
        property directoryGroup : String
        property directoryMode : String

        def initialize( @fileUser = ISM::Default::SoftwareSecurityDefaultConfiguration::FileUser,
                        @fileGroup = ISM::Default::SoftwareSecurityDefaultConfiguration::FileGroup,
                        @fileMode = ISM::Default::SoftwareSecurityDefaultConfiguration::FileMode,
                        @directoryUser = ISM::Default::SoftwareSecurityDefaultConfiguration::DirectoryUser,
                        @directoryGroup = ISM::Default::SoftwareSecurityDefaultConfiguration::DirectoryGroup,
                        @directoryMode = ISM::Default::SoftwareSecurityDefaultConfiguration::DirectoryMode)
        end

    end

end
