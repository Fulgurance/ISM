module ISM

    class CommandLinePortsSettings

        include JSON::Serializable

        property targetVersion : String

        def initialize(@targetVersion = ISM::Default::CommandLinePortsSettings::TargetVersion)
        end

        def self.filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLinePortsSettings::PortsSettingsFilePath

            rescue error
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "filePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue error
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "generateConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))

            rescue error
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "loadConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close

            rescue error
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "writeConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

        def setTargetVersion(@targetVersion)
            writeConfiguration

            rescue error
            ISM::Core::Error.show(  className: "CommandLinePortsSettings",
                                    functionName: "setTargetVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

    end

end
