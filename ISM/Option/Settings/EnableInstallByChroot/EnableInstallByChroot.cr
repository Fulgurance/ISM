module ISM

    module Option

        class SettingsEnableInstallByChroot < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableInstallByChroot::ShortText,
                        ISM::Default::Option::SettingsEnableInstallByChroot::LongText,
                        ISM::Default::Option::SettingsEnableInstallByChroot::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setInstallByChroot(true)
                        Ism.printProcessNotification(ISM::Default::Option::SettingsEnableInstallByChroot::SetText)
                    end
                end
            end

        end
        
    end

end
