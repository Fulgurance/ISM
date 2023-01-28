module ISM

    class CommandLineSystemSettings

        record SystemSettings,
            lcAll : String do
            include JSON::Serializable
        end

        property lcAll : String

        def initialize(@lcAll = ISM::Default::CommandLineSystemSettings::LcAll)
        end

        def loadSystemSettingsFile
            if !File.exists?(Ism.settings.rootPath+ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath)
                writeSystemSettingsFile
            end

            information = SystemSettings.from_json(File.read(Ism.settings.rootPath+ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath))
            @lcAll = information.lcAll
        end

        def writeSystemSettingsFile
            systemSettings = SystemSettings.new(@lcAll)

            file = File.open(Ism.settings.rootPath+ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath,"w")
            systemSettings.to_json(file)
            file.close
        end

        def setLcAll(@lcAll)
            writeSystemSettingsFile
        end

    end

end
