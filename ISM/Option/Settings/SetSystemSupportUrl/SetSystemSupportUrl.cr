module ISM

    module Option

        class SettingsSetSystemSupportUrl < ISM::CommandLineOption

            module Default

                ShortText = "-sssu"
                LongText = "setsystemsupporturl"
                Description = "Set the support url of the future installed system"
                SetText = "Setting the system support url to the value "

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemSupportUrl(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
