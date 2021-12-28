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
            information = SystemSettings.from_json(File.read(ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath))
      
            @lcAll = information.lcAll
        end

        def writeSystemSettingsFile
            systemSettings = SystemSettings.new(@lcAll)

            file = File.open(ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath,"w")
            systemSettings.to_json(file)
            file.close
        end

        def setLcAll(@lcAll)
            writeSystemSettingsFile
        end

    end

end