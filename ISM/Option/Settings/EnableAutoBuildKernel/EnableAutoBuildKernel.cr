module ISM

    module Option

        class SettingsEnableAutoBuildKernel < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableAutoBuildKernel::ShortText,
                        ISM::Default::Option::SettingsEnableAutoBuildKernel::LongText,
                        ISM::Default::Option::SettingsEnableAutoBuildKernel::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setAutoBuildKernel(true)
                    Ism.printProcessNotification(ISM::Default::Option::SettingsEnableAutoBuildKernel::SetText)
                end
            end

        end
        
    end

end
