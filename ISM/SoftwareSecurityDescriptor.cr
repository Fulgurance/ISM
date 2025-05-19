module ISM

    class SoftwareSecurityDescriptor

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
