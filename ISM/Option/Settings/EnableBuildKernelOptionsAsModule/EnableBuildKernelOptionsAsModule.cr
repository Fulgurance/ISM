module ISM

    module Option

        class SettingsEnableBuildKernelOptionsAsModule < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableBuildKernelOptionsAsModule::ShortText,
                        ISM::Default::Option::SettingsEnableBuildKernelOptionsAsModule::LongText,
                        ISM::Default::Option::SettingsEnableBuildKernelOptionsAsModule::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setBuildKernelOptionsAsModule(true)
                    Ism.printProcessNotification(ISM::Default::Option::SettingsEnableBuildKernelOptionsAsModule::SetText)
                end
            end

        end
        
    end

end
