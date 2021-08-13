module ISM

    class CommandLineSettings

        property rootPath = ISM::Default::CommandLineSettings::RootPath
        property toolsPath = ISM::Default::CommandLineSettings::ToolsPath
        property target = ISM::Default::CommandLineSettings::Target

        def initialize( rootPath = ISM::Default::CommandLineSettings::RootPath,
                        toolsPath = ISM::Default::CommandLineSettings::ToolsPath,
                        target = ISM::Default::CommandLineSettings::Target)
            @rootPath = rootPath
            @toolsPath = toolsPath
            @target = target
        end

    end

end