module ISM

    module Option

        class SettingsEnableAutoDeployServices < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableAutoDeployServices::ShortText,
                        ISM::Default::Option::SettingsEnableAutoDeployServices::LongText,
                        ISM::Default::Option::SettingsEnableAutoDeployServices::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setAutoDeployServices(true)
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsEnableAutoDeployServices::SetText)
                end
            end

        end
        
    end

end
