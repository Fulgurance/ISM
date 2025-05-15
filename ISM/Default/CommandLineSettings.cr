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
            BinaryTaskMode = false
            InstallByChroot = false
            RootPath = "/"
            DefaultMirror = "Uk"
            BuildKernelOptionsAsModule = true
            AutoDeployServices = true

            #Host related parameters
            SystemTargetName = "unknown"
            SystemArchitecture = "x86_64"
            SystemTarget = "#{SystemArchitecture}-#{SystemTargetName}-linux-gnu"
            SystemMakeOptions = "-j1"
            SystemBuildOptions = "-march=native -O2 -pipe"
            SystemName = "Unknown"
            SystemFullName ="Unknown Linux System"
            SystemId = "?"
            SystemRelease = "?"
            SystemCodeName = "?"
            SystemDescription = "None"
            SystemVersion = "?"
            SystemVersionId = "?"
            SystemAnsiColor = "?"
            SystemCpeName = "Unknown"
            SystemHomeUrl = "None"
            SystemSupportUrl = "None"
            SystemBugReportUrl = "None"
            SystemPrivacyPolicyUrl = "None"
            SystemBuildId = "?"
            SystemVariant = "None"
            SystemVariantId = "None"

            #Chroot related parameters
            ChrootTargetName = "#{SystemTargetName}"
            ChrootArchitecture = "#{SystemArchitecture}"
            ChrootTarget = "#{SystemTarget}"
            ChrootMakeOptions = "#{SystemMakeOptions}"
            ChrootBuildOptions = "#{SystemBuildOptions}"
            ChrootName = "#{SystemName}"
            ChrootFullName = "#{SystemFullName}"
            ChrootId = "#{SystemId}"
            ChrootRelease = "#{SystemRelease}"
            ChrootCodeName = "#{SystemCodeName}"
            ChrootDescription = "#{SystemDescription}"
            ChrootVersion = "#{SystemVersion}"
            ChrootVersionId = "#{SystemVersionId}"
            ChrootAnsiColor = "#{SystemAnsiColor}"
            ChrootCpeName = "#{SystemCpeName}"
            ChrootHomeUrl = "#{SystemHomeUrl}"
            ChrootSupportUrl = "#{SystemSupportUrl}"
            ChrootBugReportUrl = "#{SystemBugReportUrl}"
            ChrootPrivacyPolicyUrl = "#{SystemPrivacyPolicyUrl}"
            ChrootBuildId = "#{SystemBuildId}"
            ChrootVariant = "#{SystemVariant}"
            ChrootVariantId = "#{SystemVariantId}"

        end

    end

end
