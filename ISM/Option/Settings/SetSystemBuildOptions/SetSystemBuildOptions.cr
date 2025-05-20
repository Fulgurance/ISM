module ISM

    module Option

        class SettingsSetSystemBuildOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemBuildOptions::ShortText,
                        ISM::Default::Option::SettingsSetSystemBuildOptions::LongText,
                        ISM::Default::Option::SettingsSetSystemBuildOptions::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemBuildOptions(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemBuildOptions::SetText+ARGV[2])
                end
            end

        end
        
    end

end
