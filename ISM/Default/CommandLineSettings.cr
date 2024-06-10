module ISM

    module Default

        module CommandLineSettings

            #Class related
            MakeOptionsFilter = /-j[0-9]/
            SettingsFilePath = "#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::Settings}"
            ErrorInvalidValueText = "Invalid value detected: "
            ErrorMakeOptionsInvalidValueAdviceText = "The input value must be of the form -jX where X is the number of jobs to run simultaneously"
            ErrorChrootMakeOptionsInvalidValueAdviceText = "The input value must be of the form -jX where X is the number of jobs to run simultaneously"

            #Generic parameters
            SecureMode = true
            InstallByChroot = false
            RootPath = "/"
            DefaultMirror = "Uk"

            #Host related parameters
            TargetName = "unknow"
            Architecture = "x86_64"
            Target = "#{Architecture}-#{TargetName}-linux-gnu"
            MakeOptions = "-j1"
            BuildOptions = "-march=native -O2 -pipe"
            Name = "Unknow"
            FullName ="Unknow Linux System"
            Id = "?"
            Release = "?"
            CodeName = "?"
            Description = "None"
            Version = "?"
            AnsiColor = "?"
            CpeName = "Unknow"
            HomeUrl = "None"
            SupportUrl = "None"
            BugReportUrl = "None"
            PrivacyPolicyUrl = "None"
            BuildId = "?"
            Variant = "None"
            VariantId = "None"

            #Chroot related parameters
            ChrootTargetName = "#{TargetName}"
            ChrootArchitecture = "#{Architecture}"
            ChrootTarget = "#{Target}"
            ChrootMakeOptions = "#{MakeOptions}"
            ChrootBuildOptions = "#{BuildOptions}"
            ChrootName = "#{Name}"
            ChrootFullName = "#{FullName}"
            ChrootId = "#{Id}"
            ChrootRelease = "#{Release}"
            ChrootCodeName = "#{CodeName}"
            ChrootDescription = "#{Description}"
            ChrootVersion = "#{Version}"
            ChrootAnsiColor = "#{AnsiColor}"
            ChrootCpeName = "#{CpeName}"
            ChrootHomeUrl = "#{HomeUrl}"
            ChrootSupportUrl = "#{SupportUrl}"
            ChrootBugReportUrl = "#{BugReportUrl}"
            ChrootPrivacyPolicyUrl = "#{PrivacyPolicyUrl}"
            ChrootBuildId = "#{BuildId}"
            ChrootVariant = "#{Variant}"
            ChrootVariantId = "#{VariantId}"

        end

    end

end
