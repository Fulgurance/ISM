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
            #Check first if the target match with any special entries or with the filepath
            #Then return the matching descriptor
            @descriptors.each do |entry|
                if entry.target == ISM::Default::SoftwareSecurityDescriptor::SourcesPathEntryName
                    return entry
                end

                if entry.target == ISM::Default::SoftwareSecurityDescriptor::ToolsPathEntryName
                    return entry
                end

                if entry.target == ISM::Default::SoftwareSecurityDescriptor::RootPathEntryName
                    return entry
                end

                if entry.target == filePath
                    return entry
                end
            end

            #If there is no descriptor, return the one by default
            @descriptors.each do |entry|
                if entry.target == ISM::Default::SoftwareSecurityDescriptor::DefaultEntryName
                    return entry
                end
            end

            return ISM::SoftwareSecurityDescriptor.new
        end
    end

end
