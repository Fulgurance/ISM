module ISM

    class CommandLineMirrorsSettings

        record MirrorsSettings,
            defaultMirror : String do
            include JSON::Serializable
        end

        property defaultMirror : String

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
            mirrorsSettings = MirrorsSettings.new(@defaultMirror)

            file = File.open(filePath,"w")
            mirrorsSettings.to_json(file)
            file.close
        end

        def setDefaultMirror(@defaultMirror)
            writeMirrorsSettingsFile
        end

        def sourcesLink : String
            mirror = Mirror.new(@defaultMirror)
            mirror.loadMirrorFile
            return mirror.sourcesLink
        end

        def patchesLink : String
            mirror = Mirror.new(@defaultMirror)
            mirror.loadMirrorFile
            return mirror.patchesLink
        end

    end

end
