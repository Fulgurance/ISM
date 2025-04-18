module ISM

    module Option

        class SettingsSetSystemVariant < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemVariant::ShortText,
                        ISM::Default::Option::SettingsSetSystemVariant::LongText,
                        ISM::Default::Option::SettingsSetSystemVariant::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemVariant(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemVariant::SetText+ARGV[2])
                end
            end

        end
        
    end

end
