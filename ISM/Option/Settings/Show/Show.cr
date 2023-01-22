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
                puts "\t#{ISM::Default::Option::SettingsShow::InstallByChrootText}: #{Ism.settings.installByChroot.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::RootPathText}: #{Ism.settings.rootPath.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ToolsPathText}: #{Ism.settings.toolsPath.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SourcesPathText}: #{Ism.settings.sourcesPath.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::SystemNameText}: #{Ism.settings.systemName.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::TargetNameText}: #{Ism.settings.targetName.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::ArchitectureText}: #{Ism.settings.architecture.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::TargetText}: #{Ism.settings.target.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::MakeOptionsText}: #{Ism.settings.makeOptions.colorize(:green)}"
                puts "\t#{ISM::Default::Option::SettingsShow::BuildOptionsText}: #{Ism.settings.buildOptions.colorize(:green)}"
            end

        end

    end

end
