module ISM

    module Option

        class SettingsSetChrootTargetName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootTargetName::ShortText,
                        ISM::Default::Option::SettingsSetChrootTargetName::LongText,
                        ISM::Default::Option::SettingsSetChrootTargetName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootTargetName(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetChrootTargetName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
