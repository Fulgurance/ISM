module ISM

    class SoftwareSecurityDefaultConfiguration

        module Default

            FileUser = "root"
            FileGroup = "root"
            FileMode = "0644"
            DirectoryUser = "root"
            DirectoryGroup = "root"
            DirectoryMode = "0755"

        end

        def_clone

        include JSON::Serializable

        property fileUser : String
        property fileGroup : String
        property fileMode : String
        property directoryUser : String
        property directoryGroup : String
        property directoryMode : String

        def initialize( @fileUser = Default::FileUser,
                        @fileGroup = Default::FileGroup,
                        @fileMode = Default::FileMode,
                        @directoryUser = Default::DirectoryUser,
                        @directoryGroup = Default::DirectoryGroup,
                        @directoryMode = Default::DirectoryMode)
        end

    end

end
