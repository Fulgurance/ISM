module ISM

    module Option

        class SettingsDisableInstallByChroot < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableInstallByChroot::ShortText,
                        ISM::Default::Option::SettingsDisableInstallByChroot::LongText,
                        ISM::Default::Option::SettingsDisableInstallByChroot::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setInstallByChroot(false)
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsDisableInstallByChroot::SetText)
                end
            end

        end
        
    end

end
