module ISM

    class CommandLineSystemInformation

        include JSON::Serializable

        property crossToolchainFullyBuilt : Bool

        def initialize(@crossToolchainFullyBuilt = false)
        end

        def self.filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLineSystemInformation::SystemInformationFilePath
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close
        end

        def setCrossToolchainFullyBuilt(@crossToolchainFullyBuilt)
            writeConfiguration
        end

    end

end
