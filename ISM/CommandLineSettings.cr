module ISM

    class CommandLineSettings

        record Settings,
            rootPath : String,
            toolsPath : String,
            sourcesPath : String,
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
        property sourcesPath = ISM::Default::CommandLineSettings::SourcesPath
        property systemName = ISM::Default::CommandLineSettings::SystemName
        property targetName = ISM::Default::CommandLineSettings::TargetName
        property architecture = ISM::Default::CommandLineSettings::Architecture
        property target = ISM::Default::CommandLineSettings::Target
        property makeOptions = ISM::Default::CommandLineSettings::MakeOptions
        property buildOptions = ISM::Default::CommandLineSettings::BuildOptions

        def initialize( rootPath = ISM::Default::CommandLineSettings::RootPath,
                        toolsPath = ISM::Default::CommandLineSettings::ToolsPath,
                        sourcesPath = ISM::Default::CommandLineSettings::SourcesPath,
                        systemName = ISM::Default::CommandLineSettings::SystemName,
                        targetName = ISM::Default::CommandLineSettings::TargetName,
                        architecture = ISM::Default::CommandLineSettings::Architecture,
                        target = ISM::Default::CommandLineSettings::Target,
                        makeOptions = ISM::Default::CommandLineSettings::MakeOptions,
                        buildOptions = ISM::Default::CommandLineSettings::BuildOptions)
            @rootPath = rootPath
            @toolsPath = toolsPath
            @sourcesPath = sourcesPath
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
            @sourcesPath = information.sourcesPath
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
                                    @sourcesPath,
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

        def setRootPath(rootPath = ISM::Default::CommandLineSettings::RootPath)
            @rootPath = rootPath
            writeSettingsFile
        end

        def setToolsPath(toolsPath = ISM::Default::CommandLineSettings::ToolsPath)
            @toolsPath = toolsPath
            writeSettingsFile
        end

        def setSourcesPath(toolsPath = ISM::Default::CommandLineSettings::SourcesPath)
            @sourcesPath = sourcesPath
            writeSettingsFile
        end

        def setSystemName(systemName = ISM::Default::CommandLineSettings::SystemName)
            @systemName = systemName
            writeSettingsFile
        end

        def setTargetName(targetName = ISM::Default::CommandLineSettings::TargetName)
            @targetName = targetName
            writeSettingsFile
        end

        def setArchitecture(architecture = ISM::Default::CommandLineSettings::Architecture)
            @architecture = architecture
            writeSettingsFile
        end

        def setTarget(target = ISM::Default::CommandLineSettings::Target)
            @target = target
            writeSettingsFile
        end

        def setMakeOptions(makeOptions = ISM::Default::CommandLineSettings::MakeOptions)
            @makeOptions = makeOptions
            writeSettingsFile
        end

        def setBuildOptions(buildOptions = ISM::Default::CommandLineSettings::BuildOptions)
            @buildOptions = buildOptions
            writeSettingsFile
        end

    end

end