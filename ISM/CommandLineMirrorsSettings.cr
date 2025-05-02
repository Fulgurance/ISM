module ISM

    class CommandLineMirrorsSettings

        include JSON::Serializable

        property defaultMirror : String

        def initialize(@defaultMirror = ISM::Default::CommandLineMirrorsSettings::DefaultMirror)
        end

        def self.filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLineMirrorsSettings::MirrorsSettingsFilePath

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

        def setDefaultMirror(@defaultMirror)
            writeConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def sourcesLink : String
            return ISM::Mirror.sourcesLink(@defaultMirror)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
