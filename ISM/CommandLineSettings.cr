module ISM

    class CommandLineSettings

        record Settings,
            rootPath : String,
            toolsPath : String,
            systemName : String,
            targetName : String,
            architecture : String,
            target : String,
            makeOptions : String,
            buildOptions : String do
            include JSON::Serializable
        end

        property rootPath = ISM::Default::CommandLineSettings::RootPath
        property toolsPath = ISM::Default::CommandLineSettings::ToolsPath
        property systemName = ISM::Default::CommandLineSettings::SystemName
        property targetName = ISM::Default::CommandLineSettings::TargetName
        property architecture = ISM::Default::CommandLineSettings::Architecture
        property target = ISM::Default::CommandLineSettings::Target
        property makeOptions = ISM::Default::CommandLineSettings::MakeOptions
        property buildOptions = ISM::Default::CommandLineSettings::BuildOptions

        def initialize( rootPath = ISM::Default::CommandLineSettings::RootPath,
                        toolsPath = ISM::Default::CommandLineSettings::ToolsPath,
                        systemName = ISM::Default::CommandLineSettings::SystemName,
                        targetName = ISM::Default::CommandLineSettings::TargetName,
                        architecture = ISM::Default::CommandLineSettings::Architecture,
                        target = ISM::Default::CommandLineSettings::Target,
                        makeOptions = ISM::Default::CommandLineSettings::MakeOptions,
                        buildOptions = ISM::Default::CommandLineSettings::BuildOptions)
            @rootPath = rootPath
            @toolsPath = toolsPath
            @systemName = systemName
            @targetName = targetName
            @architecture = architecture
            @target = target
            @makeOptions = makeOptions
            @buildOptions = buildOptions
        end

        def loadSettingsFile(settingsFilePath = ISM::Default::CommandLineSettings::SettingsFilePath)
            information = Settings.from_json(File.read(settingsFilePath))
      
            @rootPath = information.rootPath
            @toolsPath = information.toolsPath
            @systemName = information.systemName
            @targetName = information.targetName
            @architecture = information.architecture
            @target = information.target
            @makeOptions = information.makeOptions
            @buildOptions = information.buildOptions
        end

        def writeSettingsFile(settingsFilePath = ISM::Default::CommandLineSettings::SettingsFilePath)
            settings = Settings.new(@rootPath,
                                    @toolsPath,
                                    @systemName,
                                    @targetName,
                                    @architecture,
                                    @target,
                                    @makeOptions,
                                    @buildOptions)

            file = File.open(settingsFilePath,"w")
            settings.to_json(file)
            file.close
        end

    end

end