module ISM

    module Option

        class SettingsDisableAutoDeployServices < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableAutoDeployServices::ShortText,
                        ISM::Default::Option::SettingsDisableAutoDeployServices::LongText,
                        ISM::Default::Option::SettingsDisableAutoDeployServices::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setAutoDeployServices(false)
                    Ism.printProcessNotification(ISM::Default::Option::SettingsDisableAutoDeployServices::SetText)
                end
            end

        end
        
    end

end
