module ISM

    module Option

        class SettingsDisableAutoBuildKernel < ISM::CommandLineOption

            module Default

                ShortText = "-dabk"
                LongText = "disableautobuildkernel"
                Description = "Disable automatic kernel building"
                SetText = "Disabling automatic kernel building"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setAutoBuildKernel(false)
                    Ism.printProcessNotification(Default::SetText)
                end
            end

        end
        
    end

end
