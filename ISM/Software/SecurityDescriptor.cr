module ISM

    class Software

        class SecurityDescriptor

            module Default

                SourcesPathEntryName = "Sources"
                ToolsPathEntryName = "Tools"

            end

            def_clone

            include JSON::Serializable

            property target : String
            property user : String
            property group : String
            property mode : String

            def initialize( @target = String.new,
                            @user = String.new,
                            @group = String.new,
                            @mode = String.new)
            end

        end

    end

end
