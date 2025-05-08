module ISM

    module Option

        class SettingsEnableBinaryTaskMode < ISM::CommandLineOption

            module Default
                ShortText = "-ebtm"
                LongText = "enablebinarytaskmode"
                Description = "Enable compilation for ism tasks. Improve highly task speed, at cost of compilation time."
                SetText = "Enable binary task mode"
            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setBinaryTaskMode(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end
            end

        end
        
    end

end
