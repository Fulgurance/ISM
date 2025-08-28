module ISM

    module Option

        class SettingsEnableAutoDeployServices < ISM::CommandLineOption

            module Default

                ShortText = "-eads"
                LongText = "enableautodeployservices"
                Description = "Enable service automatic deployement"
                SetText = "Enabling service automatic deployement"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    Ism.settings.setAutoDeployServices(true)
                    Ism.printProcessNotification(Default::SetText)
                end
            end

        end
        
    end

end
