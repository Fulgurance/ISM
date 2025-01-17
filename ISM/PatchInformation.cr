module ISM

    class PatchInformation

        include JSON::Serializable

        property id : String
        property referenceUrl : String
        property author : String
        property title : String
        property description : String

        def initialize( @id = String.new,
                        @referenceUrl = String.new,
                        @author = String.new,
                        @title = String.new,
                        @description = String.new)
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

        # FUNCTION EXAMPLE
        # def setCrossToolchainFullyBuilt(@crossToolchainFullyBuilt)
        #     writeConfiguration
        #
        #     rescue error
        #         Ism.printSystemCallErrorNotification(error)
        #         Ism.exitProgram
        # end

    end

end
