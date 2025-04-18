module ISM

    module Option

        class SettingsSetSystemAnsiColor < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemAnsiColor::ShortText,
                        ISM::Default::Option::SettingsSetSystemAnsiColor::LongText,
                        ISM::Default::Option::SettingsSetSystemAnsiColor::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemAnsiColor(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemAnsiColor::SetText+ARGV[2])
                end
            end

        end
        
    end

end
