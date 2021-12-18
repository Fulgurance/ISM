module ISM

    module Default

        module CommandLineSettings

            RootPath = "/"
            ToolsPath = "/tools"
            SourcesPath = "/sources"
            SystemName = "Unknow"
            TargetName = "unknow"
            Architecture = "x86_64"
            Target = "#{Architecture}-#{TargetName}-linux-gnu"
            MakeOptions = "-j1"
            BuildOptions = "-march=native -O2 -pipe"
            SettingsFilePath = "./Settings/ISM/Settings.json"

        end

    end

end
