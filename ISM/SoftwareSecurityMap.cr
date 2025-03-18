module ISM

    class SoftwareSecurityMap

        include JSON::Serializable

        property defaultConfiguration : ISM::SoftwareSecurityDefaultConfiguration
        property descriptors : Array(ISM::SoftwareSecurityDescriptor)

        def initialize( @defaultConfiguration = ISM::SoftwareSecurityDefaultConfiguration.new,
                        @descriptors = Array(ISM::SoftwareSecurityDescriptor).new)
        end

        def self.loadConfiguration(path = String.new)
            return from_json(File.read(path))

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def descriptor(filePath : String) : ISM::SoftwareSecurityDescriptor
            path = filePath.squeeze("/")
            directory = (File.directory?(path) && !File.symlink?(path))

            user = String.new
            group = String.new
            mode = String.new

            if Ism.systemInformation.handleUserAccess
                #Return the matching descriptor
                @descriptors.each do |entry|
                    #Special entry for sources path
                    if entry.target == ISM::Default::SoftwareSecurityDescriptor::SourcesPathEntryName && path == Ism.settings.sourcesPath
                        return entry
                    end

                    #Special entry for tools path
                    if entry.target == ISM::Default::SoftwareSecurityDescriptor::ToolsPathEntryName && path == Ism.settings.toolsPath
                        return entry
                    end

                    if entry.target == filePath
                        return entry
                    end
                end

                #TO DO: ADD ADDITIONAL STEP TO CHECK IF THERE IS ANY PARENT DIRECTORY THAT WE SHOULD INHERIT RECURSIVELY OF THE RIGHTS


                #Apply default the default configuration for directory and file
                user = (directory ? @defaultConfiguration.directoryUser : @defaultConfiguration.fileUser)
                group = (directory ? @defaultConfiguration.directoryGroup : @defaultConfiguration.fileGroup)
                mode = (directory ? @defaultConfiguration.directoryMode : @defaultConfiguration.fileMode)
            else
                #Set everything with default ism user, group and mode for directory and file
                user = ISM::Default::CommandLine::SystemId
                group = ISM::Default::CommandLine::SystemId
                mode = (directory ? ISM::Default::SoftwareSecurityMap::DirectoryMode : ISM::Default::SoftwareSecurityMap::FileMode)
            end

            return ISM::SoftwareSecurityDescriptor.new( target: path,
                                                        user:   user,
                                                        group:  group,
                                                        mode:   mode)
        end
    end

end
