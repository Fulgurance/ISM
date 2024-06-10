module ISM

    module Option

        class SettingsShow < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsShow::ShortText,
                        ISM::Default::Option::SettingsShow::LongText,
                        ISM::Default::Option::SettingsShow::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                puts "#{ISM::Default::Option::SettingsShow::TitleText}:".colorize(:yellow)
                puts "\t#{ISM::Default::Option::SettingsShow::DefaultMirrorText}: #{Ism.settings.defaultMirror.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SecureModeText}: #{Ism.settings.secureMode.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::InstallByChrootText}: #{Ism.settings.installByChroot.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::RootPathText}: #{Ism.settings.rootPath.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::NameText}: #{Ism.settings.name(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::TargetNameText}: #{Ism.settings.targetName(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ArchitectureText}: #{Ism.settings.architecture(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::TargetText}: #{Ism.settings.target(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::MakeOptionsText}: #{Ism.settings.makeOptions(false).colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::BuildOptionsText}: #{Ism.settings.buildOptions(false).colorize(:green)}"
                puts "\t=========================".colorize(:green)
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootNameText}: #{Ism.settings.chrootName.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootTargetNameText}: #{Ism.settings.chrootTargetName.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootArchitectureText}: #{Ism.settings.chrootArchitecture.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootTargetText}: #{Ism.settings.chrootTarget.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootMakeOptionsText}: #{Ism.settings.chrootMakeOptions.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ChrootBuildOptionsText}: #{Ism.settings.chrootBuildOptions.colorize(:green)}"
            end

        end

    end

end
