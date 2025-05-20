module ISM

    module Option

        class SettingsDisableBuildKernelOptionsAsModule < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableBuildKernelOptionsAsModule::ShortText,
                        ISM::Default::Option::SettingsDisableBuildKernelOptionsAsModule::LongText,
                        ISM::Default::Option::SettingsDisableBuildKernelOptionsAsModule::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setBuildKernelOptionsAsModule(false)
                    Ism.printProcessNotification(ISM::Default::Option::SettingsDisableBuildKernelOptionsAsModule::SetText)
                end
            end

        end
        
    end

end
