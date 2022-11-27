module ISM

    module Default

        module CommandLineSettings

            RootPath = "/"
            SystemName = "Unknow"
            TargetName = "unknow"
            Architecture = "x86_64"
            Target = "#{Architecture}-#{TargetName}-linux-gnu"
            MakeOptions = "-j1"
            BuildOptions = "-march=native -O2 -pipe"
            SettingsFilePath = "#{ISM::Default::Path::SettingsIsmDirectory}Settings.json"

        end

    end

end
