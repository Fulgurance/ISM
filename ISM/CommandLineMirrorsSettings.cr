module ISM

    class CommandLineMirrorsSettings

        include JSON::Serializable

        property defaultMirror : String

        def initialize(@defaultMirror = ISM::Default::CommandLineMirrorsSettings::DefaultMirror)
        end

        def self.filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLineMirrorsSettings::MirrorsSettingsFilePath
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

            return from_json(File.read(path))
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close
        end

        def setDefaultMirror(@defaultMirror)
            writeConfiguration
        end

        def sourcesLink : String
            return ISM::Mirror.sourcesLink(@defaultMirror)
        end

        def patchesLink : String
            return ISM::Mirror.patchesLink(@defaultMirror)
        end

    end

end
