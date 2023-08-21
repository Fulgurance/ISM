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

        def filePath : String
            return Ism.settings.rootPath+ISM::Default::Path::MirrorsDirectory+@codeName+".json"
        end

        def loadMirrorFile
            if !File.exists?(filePath)
                writeMirrorFile
            end

            information = Mirror.from_json(File.read(filePath))
            @codeName = information.codeName
            @urls = information.urls
            @mainUrl = information.mainUrl
        end

        def writeMirrorFile
            mirror = Mirror.new(@codeName,
                                @urls,
                                @mainUrl)

            file = File.open(filePath,"w")
            mirror.to_json(file)
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
