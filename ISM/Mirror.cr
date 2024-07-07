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
            self.new.to_json
            file.close
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            from_json(File.read(path))
        end

        def loadConfiguration(path = self.class.filePath)
            if !File.exists?(path)
                writeConfiguration(path)
            end

            self.class.from_json(File.read(path))
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close
        end

        def defaultUrl : String
            return @urls[@mainUrl]
        end

        def sourcesLink : String
            return defaultUrl+ISM::Default::Mirror::SourcesLinkDirectory
        end

        def patchesLink : String
            return defaultUrl+ISM::Default::Mirror::PatchesLinkDirectory
        end

    end

end
