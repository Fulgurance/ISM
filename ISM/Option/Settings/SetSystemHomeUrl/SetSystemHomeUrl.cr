module ISM

    module Option

        class SettingsSetSystemHomeUrl < ISM::CommandLineOption

            module Default

                ShortText = "-sshu"
                LongText = "setsystemhomeurl"
                Description = "Set the home url of the future installed system"
                SetText = "Setting the system home url to the value "

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
                    Ism.settings.setSystemHomeUrl(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
