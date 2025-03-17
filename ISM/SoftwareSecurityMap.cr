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
                #Special entry for sources path
                if entry.target == ISM::Default::SoftwareSecurityDescriptor::SourcesPathEntryName && filePath.squeeze("/") == Ism.settings.sourcesPath
                    return entry
                end

                #Special entry for tools path
                if entry.target == ISM::Default::SoftwareSecurityDescriptor::ToolsPathEntryName && filePath.squeeze("/") == Ism.settings.toolsPath
                    return entry
                end

                if entry.target == filePath
                    return entry
                end
            end

            #ADD ADDITIONAL STEP TO CHECK IF THERE IS ANY PARENT DIRECTORY THAT WE SHOULD INHERIT RECURSIVELY OF THE RIGHTS

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
