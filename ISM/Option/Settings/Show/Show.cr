module ISM

    module Option

        class SettingsShow < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsShow::ShortText,
                        ISM::Default::Option::SettingsShow::LongText,
                        ISM::Default::Option::SettingsShow::Description)
            end

            def start
                puts "#{ISM::Default::Option::SettingsShow::TitleText}:".colorize(:yellow)

                puts "\t#{ISM::Default::Option::SettingsShow::SecureModeText}: #{Ism.settings.secureMode.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::InstallByChrootText}: #{Ism.settings.installByChroot.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::RootPathText}: #{Ism.settings.rootPath.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::DefaultMirrorText}: #{Ism.settings.defaultMirror.colorize(:green)}"

                puts "\t#{ISM::Default::Option::SettingsShow::SystemTargetNameText}: #{Ism.settings.systemTargetName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemArchitectureText}: #{Ism.settings.systemArchitecture(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemTargetText}: #{Ism.settings.systemTarget(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemMakeOptionsText}: #{Ism.settings.systemMakeOptions(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemBuildOptionsText}: #{Ism.settings.systemBuildOptions(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemNameText}: #{Ism.settings.systemName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemFullNameText}: #{Ism.settings.systemFullName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemIdText}: #{Ism.settings.systemId(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemReleaseText}: #{Ism.settings.systemRelease(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemCodeNameText}: #{Ism.settings.systemCodeName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemDescriptionText}: #{Ism.settings.systemDescription(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemVersionText}: #{Ism.settings.systemVersion(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemAnsiColorText}: #{Ism.settings.systemAnsiColor(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemCpeNameText}: #{Ism.settings.systemCpeName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemHomeUrlText}: #{Ism.settings.systemHomeUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemSupportUrlText}: #{Ism.settings.systemSupportUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemBugReportUrlText}: #{Ism.settings.systemBugReportUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemPrivacyPolicyUrlText}: #{Ism.settings.systemPrivacyPolicyUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemBuildIdText}: #{Ism.settings.systemBuildId(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemVariantText}: #{Ism.settings.systemVariant(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemVariantIdText}: #{Ism.settings.systemVariantId(false).colorize(:green)}"

                puts "\t=========================".colorize(:green)

                puts "\t#{ISM::Default::Option::SettingsShow::ChrootTargetNameText}: #{Ism.settings.chrootTargetName.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootArchitectureText}: #{Ism.settings.chrootArchitecture.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootTargetText}: #{Ism.settings.chrootTarget.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootMakeOptionsText}: #{Ism.settings.chrootMakeOptions.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootBuildOptionsText}: #{Ism.settings.chrootBuildOptions.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootNameText}: #{Ism.settings.chrootName.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootFullNameText}: #{Ism.settings.chrootFullName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootIdText}: #{Ism.settings.chrootId(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootReleaseText}: #{Ism.settings.chrootRelease(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootCodeNameText}: #{Ism.settings.chrootCodeName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootDescriptionText}: #{Ism.settings.chrootDescription(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootVersionText}: #{Ism.settings.chrootVersion(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootAnsiColorText}: #{Ism.settings.chrootAnsiColor(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootCpeNameText}: #{Ism.settings.chrootCpeName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootHomeUrlText}: #{Ism.settings.chrootHomeUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootSupportUrlText}: #{Ism.settings.chrootSupportUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootBugReportUrlText}: #{Ism.settings.chrootBugReportUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootPrivacyPolicyUrlText}: #{Ism.settings.chrootPrivacyPolicyUrl(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootBuildIdText}: #{Ism.settings.chrootBuildId(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootVariantText}: #{Ism.settings.chrootVariant(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootVariantIdText}: #{Ism.settings.chrootVariantId(false).colorize(:green)}"
            end

        end

    end

end
