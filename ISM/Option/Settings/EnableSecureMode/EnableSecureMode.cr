module ISM

    module Option

        class SettingsEnableSecureMode < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableSecureMode::ShortText,
                        ISM::Default::Option::SettingsEnableSecureMode::LongText,
                        ISM::Default::Option::SettingsEnableSecureMode::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSecureMode(true)
                        Ism.printProcessNotification(ISM::Default::Option::SettingsEnableSecureMode::SetText)
                    end
                end
            end

        end
        
    end

end
