module ISM

    class CommandLineMirrorsSettings

        record MirrorsSettings,
            defaultMirror : String do
            include JSON::Serializable
        end

        property targetVersion : String

        def initialize(@defaultMirror = ISM::Default::CommandLineMirrorsSettings::DefaultMirror)
        end

        def filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLineMirrorsSettings::MirrorsSettingsFilePath
        end

        def loadMirrorsSettingsFile
            if !File.exists?(filePath)
                writeMirrorsSettingsFile
            end

            information = MirrorsSettings.from_json(File.read(filePath))
            @defaultMirror = information.defaultMirror
        end

        def writeMirrorsSettingsFile
            mirrorsSettings = MirrorsSettings.new(@mirrorsSettings)

            file = File.open(filePath,"w")
            mirrorsSettings.to_json(file)
            file.close
        end

        def setDefaultMirror(@defaultMirror)
            writeMirrorsSettingsFile
        end

    end

end
