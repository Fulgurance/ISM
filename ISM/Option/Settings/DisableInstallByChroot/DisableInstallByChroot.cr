module ISM

    module Option

        class SettingsDisableInstallByChroot < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableInstallByChroot::ShortText,
                        ISM::Default::Option::SettingsDisableInstallByChroot::LongText,
                        ISM::Default::Option::SettingsDisableInstallByChroot::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setInstallByChroot(false)
                        Ism.printProcessNotification(ISM::Default::Option::SettingsDisableInstallByChroot::SetText)
                    end
                end
            end

        end
        
    end

end
