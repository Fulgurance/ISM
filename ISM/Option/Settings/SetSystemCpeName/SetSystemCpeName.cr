module ISM

    module Option

        class SettingsSetSystemCpeName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemCpeName::ShortText,
                        ISM::Default::Option::SettingsSetSystemCpeName::LongText,
                        ISM::Default::Option::SettingsSetSystemCpeName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemCpeName(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemCpeName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
