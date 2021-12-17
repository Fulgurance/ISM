module ISM

    class CommandLineSystemSettings

        record SystemSettings,
            lcAll : String do
            include JSON::Serializable
        end

        property lcAll = ISM::Default::CommandLineSystemSettings::LcAll

        def initialize( lcAll = ISM::Default::CommandLineSystemSettings::LcAll)
            @lcAll = lcAll
        end

        def loadSystemSettingsFile(systemSettingsFilePath = ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath)
            information = SystemSettings.from_json(File.read(systemSettingsFilePath))
      
            @lcAll = information.lcAll
        end

        def writeSystemSettingsFile(systemSettingsFilePath = ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath)
            systemSettings = SystemSettings.new(@lcAll)

            file = File.open(systemSettingsFilePath,"w")
            systemSettings.to_json(file)
            file.close
        end
    end

end