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
            InstallByChroot = false
            ChrootSystemName = "#{SystemName}"
            ChrootTargetName = "#{TargetName}"
            ChrootArchitecture = "#{Architecture}"
            ChrootTarget = "#{Target}"
            MakeOptionsFilter = /-j[0-9]/
            ChrootMakeOptions = "#{MakeOptions}"
            ChrootBuildOptions = "#{BuildOptions}"
            DefaultMirror = "Uk"
            SettingsFilePath = "#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::Settings}"
            ErrorMakeOptionsInvalidValueText = "Invalid value detected: "
            ErrorMakeOptionsInvalidValueAdviceText = "The input value must be of the form -jX where X is the number of jobs to run simultaneously"

        end

    end

end
