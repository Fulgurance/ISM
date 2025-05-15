module ISM

    class CommandLinePortsSettings

        include JSON::Serializable

        property targetVersion : String

        def initialize(@targetVersion = ISM::Default::CommandLinePortsSettings::TargetVersion)
        end

        def self.filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLinePortsSettings::PortsSettingsFilePath
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "CommandLinePortSettings",
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
                ISM::Error.show(className: "CommandLinePortSettings",
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
                ISM::Error.show(className: "CommandLinePortSettings",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setTargetVersion(@targetVersion)
            writeConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLinePortSettings",
                                functionName: "setTargetVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
