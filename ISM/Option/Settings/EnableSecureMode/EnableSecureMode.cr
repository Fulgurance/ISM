module ISM

    module Option

        class SettingsEnableSecureMode < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableInstallByChroot::ShortText,
                        ISM::Default::Option::SettingsEnableSecureMode::LongText,
                        ISM::Default::Option::SettingsEnableSecureMode::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
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
