module ISM

    module Option

        class SettingsSetSystemName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemName::ShortText,
                        ISM::Default::Option::SettingsSetSystemName::LongText,
                        ISM::Default::Option::SettingsSetSystemName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemName(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
