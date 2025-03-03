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

        def descriptor(filePath : String) : ISM::SoftwareSecurityDescriptor
            #Return the matching descriptor
            @descriptors.each do |entry|
                if entry.target == filePath
                    return entry
                end
            end

            return @descriptors[0]
        end
    end

end
