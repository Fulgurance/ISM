module ISM

    module Option

        class SettingsSetChrootSupportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootSupportUrl::ShortText,
                        ISM::Default::Option::SettingsSetChrootSupportUrl::LongText,
                        ISM::Default::Option::SettingsSetChrootSupportUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootSupportUrl(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetChrootSupportUrl::SetText+ARGV[2])
                end
            end

        end
        
    end

end
