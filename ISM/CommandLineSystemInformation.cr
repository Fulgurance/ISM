module ISM

    class CommandLineSystemInformation

        module Default
            FilePath = "#{Path::SettingsDirectory}#{Filename::SystemInformation}"
        end

        include JSON::Serializable

        property crossToolchainFullyBuilt : Bool

        def initialize(@crossToolchainFullyBuilt = false)
        end

        def self.filePath : String
            return Ism.settings.rootPath+Default::FilePath

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setCrossToolchainFullyBuilt(@crossToolchainFullyBuilt)
            writeConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
