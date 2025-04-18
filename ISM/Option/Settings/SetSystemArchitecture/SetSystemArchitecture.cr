module ISM

    module Option

        class SettingsSetSystemArchitecture < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemArchitecture::ShortText,
                        ISM::Default::Option::SettingsSetSystemArchitecture::LongText,
                        ISM::Default::Option::SettingsSetSystemArchitecture::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemArchitecture(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemArchitecture::SetText+ARGV[2])
                end
            end

        end
        
    end

end
