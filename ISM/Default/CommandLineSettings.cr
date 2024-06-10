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
            SystemTargetName = "unknow"
            SystemArchitecture = "x86_64"
            SystemTarget = "#{Architecture}-#{TargetName}-linux-gnu"
            SystemMakeOptions = "-j1"
            SystemBuildOptions = "-march=native -O2 -pipe"
            SystemName = "Unknow"
            SystemFullName ="Unknow Linux System"
            SystemId = "?"
            SystemRelease = "?"
            SystemCodeName = "?"
            SystemDescription = "None"
            SystemVersion = "?"
            SystemAnsiColor = "?"
            SystemCpeName = "Unknow"
            SystemHomeUrl = "None"
            SystemSupportUrl = "None"
            SystemBugReportUrl = "None"
            SystemPrivacyPolicyUrl = "None"
            SystemBuildId = "?"
            SystemVariant = "None"
            SystemVariantId = "None"

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
