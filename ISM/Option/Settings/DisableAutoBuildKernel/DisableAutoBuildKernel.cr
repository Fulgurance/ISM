module ISM

    module Option

        class SettingsDisableAutoBuildKernel < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableAutoBuildKernel::ShortText,
                        ISM::Default::Option::SettingsDisableAutoBuildKernel::LongText,
                        ISM::Default::Option::SettingsDisableAutoBuildKernel::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setAutoBuildKernel(false)
                    Ism.printProcessNotification(ISM::Default::Option::SettingsDisableAutoBuildKernel::SetText)
                end
            end

        end
        
    end

end
