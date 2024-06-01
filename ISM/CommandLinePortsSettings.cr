module ISM
  class CommandLinePortsSettings
    record PortsSettings,
      targetVersion : String do
      include JSON::Serializable
    end

    property targetVersion : String

    def initialize(@targetVersion = ISM::Default::CommandLinePortsSettings::TargetVersion)
    end

    def filePath : String
      Ism.settings.rootPath + ISM::Default::CommandLinePortsSettings::PortsSettingsFilePath
    end

    def loadPortsSettingsFile
      if !File.exists?(filePath)
        writePortsSettingsFile
      end

      information = PortsSettings.from_json(File.read(filePath))
      @targetVersion = information.targetVersion
    end

    def writePortsSettingsFile
      portsSettings = PortsSettings.new(@targetVersion)

      file = File.open(filePath, "w")
      portsSettings.to_json(file)
      file.close
    end

    def setTargetVersion(@targetVersion)
      writePortsSettingsFile
    end
  end
end
