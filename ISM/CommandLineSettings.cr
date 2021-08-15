module ISM

    class CommandLineSettings

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

    end

end