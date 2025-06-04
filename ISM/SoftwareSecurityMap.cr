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

            rescue exception
            ISM::Error.show(className: "SoftwareSecurityMap",
                            functionName: "loadConfiguration",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end

        def descriptor(path : String, realPath : String) : ISM::SoftwareSecurityDescriptor
            path = path.squeeze("/")

            directory = (File.directory?(realPath) && !File.symlink?(realPath))

            user = String.new
            group = String.new
            mode = String.new

            #Return the matching descriptor
            @descriptors.each do |entry|
                #Special entry for sources path
                if entry.target == ISM::Default::SoftwareSecurityDescriptor::SourcesPathEntryName && path == "/#{ISM::Default::Path::SourcesDirectory}"[0..-2]
                    return entry
                end

                #Special entry for tools path
                if entry.target == ISM::Default::SoftwareSecurityDescriptor::ToolsPathEntryName && path == "/#{ISM::Default::Path::ToolsDirectory}"[0..-2]
                    return entry
                end

                if entry.target == path
                    return entry
                end
            end

            #TO DO: ADD ADDITIONAL STEP TO CHECK IF THERE IS ANY PARENT DIRECTORY THAT WE SHOULD INHERIT RECURSIVELY OF THE RIGHTS

            #Apply default the default configuration for directory and file
            user = (directory ? @defaultConfiguration.directoryUser : @defaultConfiguration.fileUser)
            group = (directory ? @defaultConfiguration.directoryGroup : @defaultConfiguration.fileGroup)
            mode = (directory ? @defaultConfiguration.directoryMode : @defaultConfiguration.fileMode)

            return ISM::SoftwareSecurityDescriptor.new( target: path,
                                                        user:   user,
                                                        group:  group,
                                                        mode:   mode)

            rescue exception
            ISM::Error.show(className: "SoftwareOption",
                            functionName: "descriptor",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end
    end

end
