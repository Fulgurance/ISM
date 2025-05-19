module ISM

    class CommandLineSystemInformation

        include JSON::Serializable

        property crossToolchainFullyBuilt : Bool
        property handleChroot : Bool

        def initialize( @crossToolchainFullyBuilt = false,
                        @handleChroot = false)
        end

        def self.filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLineSystemInformation::SystemInformationFilePath
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "CommandLineSystemInformation",
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
                ISM::Error.show(className: "CommandLineSystemInformation",
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
                ISM::Error.show(className: "CommandLineSystemInformation",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setCrossToolchainFullyBuilt(@crossToolchainFullyBuilt)
            writeConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSystemInformation",
                                functionName: "setCrossToolchainFullyBuilt",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setHandleChroot(@handleChroot)
            writeConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSystemInformation",
                                functionName: "setHandleChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
