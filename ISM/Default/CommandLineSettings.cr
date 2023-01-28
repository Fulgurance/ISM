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
            ChrootTargetName = "#{ChrootTargetName}"
            ChrootArchitecture = "#{ChrootArchitecture}"
            ChrootTarget = "#{ChrootTarget}"
            ChrootMakeOptions = "#{ChrootMakeOptions}"
            ChrootBuildOptions = "#{ChrootBuildOptions}"
            SettingsFilePath = "#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::Settings}"


        end

    end

end
