module ISM

    class CommandLineSystemSettings

        record SystemSettings,
            lcAll : String do
            include JSON::Serializable
        end

        property lcAll : String

        def initialize(@lcAll = ISM::Default::CommandLineSystemSettings::LcAll)
        end

        def filePath : String
            return Ism.settings.rootPath+ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath
        end

        def loadSystemSettingsFile
            if !File.exists?(filePath)
                writeSystemSettingsFile
            end

            information = SystemSettings.from_json(File.read(filePath))
            @lcAll = information.lcAll
        end

        def writeSystemSettingsFile
            systemSettings = SystemSettings.new(@lcAll)

            file = File.open(filePath,"w")
            systemSettings.to_json(file)
            file.close
        end

        def setLcAll(@lcAll)
            writeSystemSettingsFile
        end

    end

end
