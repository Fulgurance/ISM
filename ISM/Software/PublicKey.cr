module ISM

    class Software

        class PublicKey

            include JSON::Serializable

            property author : String
            property email : String
            property url : String

            def initialize( @author = String.new,
                            @email = String.new,
                            @url = String.new)
            end

            def self.loadConfiguration(path = String.new)
                return from_json(File.read(path))

                rescue exception
                ISM::Error.show(className: "PublicKey",
                                functionName: "loadConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

        end

    end

end
