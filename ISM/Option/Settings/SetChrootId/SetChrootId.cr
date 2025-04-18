module ISM

    module Option

        class SettingsSetChrootId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootId::ShortText,
                        ISM::Default::Option::SettingsSetChrootId::LongText,
                        ISM::Default::Option::SettingsSetChrootId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootId(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetChrootId::SetText+ARGV[2])
                end
            end

        end
        
    end

end
