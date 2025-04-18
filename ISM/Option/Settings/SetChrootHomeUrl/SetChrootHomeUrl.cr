module ISM

    module Option

        class SettingsSetChrootHomeUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootHomeUrl::ShortText,
                        ISM::Default::Option::SettingsSetChrootHomeUrl::LongText,
                        ISM::Default::Option::SettingsSetChrootHomeUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootHomeUrl(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetChrootHomeUrl::SetText+ARGV[2])
                end
            end

        end
        
    end

end
