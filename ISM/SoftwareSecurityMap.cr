module ISM

    class SoftwareSecurityMap

        include JSON::Serializable

        property descriptors : Array(ISM::SoftwareSecurityDescriptor)

        def initialize( @descriptors = Array(ISM::SoftwareSecurityDescriptor).new)
        end

        def self.loadConfiguration(path = String.new)
            return from_json(File.read(path))

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
