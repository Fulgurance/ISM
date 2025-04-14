module ISM

    module Option

        class SettingsSetSystemBuildId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemBuildId::ShortText,
                        ISM::Default::Option::SettingsSetSystemBuildId::LongText,
                        ISM::Default::Option::SettingsSetSystemBuildId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemBuildId(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemBuildId::SetText+ARGV[2])
                end
            end

        end
        
    end

end
