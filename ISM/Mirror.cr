module ISM

    class Mirror

        include JSON::Serializable

        property codeName : String
        property urls : Array(String)
        property mainUrl : Int32

        def initialize( @codeName = ISM::Default::Mirror::CodeName,
                        @urls = ISM::Default::Mirror::Urls,
                        @mainUrl = ISM::Default::Mirror::MainUrl)
        end

        def self.filePath(codeName = ISM::Default::Mirror::CodeName) : String
            return Ism.settings.rootPath+ISM::Default::Path::MirrorsDirectory+codeName+".json"
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "Mirror",
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
                ISM::Error.show(className: "Mirror",
                                functionName: "loadConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def self.sourcesLink(codeName : String) : String
            begin
                return from_json(File.read(filePath(codeName))).sourcesLink
            rescue
                return String.new
            end

            rescue exception
                ISM::Error.show(className: "Mirror",
                                functionName: "sourcesLink",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "Mirror",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def defaultUrl : String
            return @urls[@mainUrl]
        end

        def sourcesLink : String
            return defaultUrl+ISM::Default::Mirror::SourcesLinkDirectory
        end

    end

end
