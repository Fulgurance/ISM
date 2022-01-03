module ISM

    class Port

        record Port,
            name : String,
            url : String do
            include JSON::Serializable
        end

        property name : String
        property url : String

        def initialize(@name = String.new,@url = String.new)
        end

        def loadPortFile(portFilePath : String)
            port = Port.from_json(File.read(portFilePath))
      
            @name = port.name
            @url = port.url
        end

        def writePortFile(portFilePath : String)
            port = Port.new(@name,@url)

            file = File.open(portFilePath,"w")
            port.to_json(file)
            file.close
        end

    end

end