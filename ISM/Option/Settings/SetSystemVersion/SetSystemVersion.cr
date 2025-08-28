module ISM

    module Option

        class SettingsSetSystemVersion < ISM::CommandLineOption

            module Default

                ShortText = "-ssv"
                LongText = "setsystemversion"
                Description = "Set the version of the future installed system"
                SetText = "Setting the system version to the value "

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
                    Ism.settings.setSystemVersion(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
