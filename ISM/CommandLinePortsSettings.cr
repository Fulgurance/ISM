module ISM

    class CommandLinePortsSettings

        record PortsSettings,
            targetVersion : String do
            include JSON::Serializable
        end

        property targetVersion : String

        def initialize(@targetVersion = ISM::Default::CommandLinePortsSettings::TargetVersion)
        end

        def loadPortsSettingsFile
            if !File.exists?(Ism.settings.rootPath+ISM::Default::CommandLinePortsSettings::PortsSettingsFilePath)
                writePortsSettingsFile
            end
            information = PortsSettings.from_json(File.read(Ism.settings.rootPath+ISM::Default::CommandLinePortsSettings::PortsSettingsFilePath))
            @targetVersion = information.targetVersion
        end

        def writePortsSettingsFile
            portsSettings = PortsSettings.new(@targetVersion)

            file = File.open(Ism.settings.rootPath+ISM::Default::CommandLinePortsSettings::PortsSettingsFilePath,"w")
            portsSettings.to_json(file)
            file.close
        end

        def setTargetVersion(@targetVersion)
            writePortsSettingsFile
        end

    end

end
