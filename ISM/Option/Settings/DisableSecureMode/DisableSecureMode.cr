module ISM

    module Option

        class SettingsDisableSecureMode < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableSecureMode::ShortText,
                        ISM::Default::Option::SettingsDisableSecureMode::LongText,
                        ISM::Default::Option::SettingsDisableSecureMode::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    if !Ism.ranAsSuperUser
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSecureMode(false)
                        Ism.printProcessNotification(ISM::Default::Option::SettingsDisableSecureMode::SetText)
                    end
                end
            end

        end
        
    end

end
