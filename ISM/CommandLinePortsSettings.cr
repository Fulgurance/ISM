module ISM

    class CommandLinePortsSettings

        module Default
            TargetVersion = "master"
            FilePath = "#{Path::SettingsDirectory}#{Filename::PortsSettings}"
        end

        include JSON::Serializable

        property targetVersion : String

        def initialize(@targetVersion = Default::TargetVersion)
        end

        def self.filePath : String
            return Ism.settings.rootPath+Default::FilePath

            rescue exception
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "filePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue exception
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "generateConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))

            rescue exception
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "loadConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close

            rescue exception
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "writeConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def setTargetVersion(@targetVersion)
            writeConfiguration

            rescue exception
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "setTargetVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

    end

end

