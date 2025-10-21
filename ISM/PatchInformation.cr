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

            rescue exception
                ISM::Error.show(className: "PatchInformation",
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
                ISM::Error.show(className: "PatchInformation",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
