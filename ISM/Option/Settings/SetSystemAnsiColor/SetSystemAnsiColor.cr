module ISM

    module Option

        class SettingsSetSystemAnsiColor < ISM::CommandLineOption

            module Default

                ShortText = "-ssac"
                LongText = "setsystemansicolor"
                Description = "Set the ANSI color of the future installed system"
                SetText = "Setting the system ANSI color to the value "

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
                    Ism.settings.setSystemAnsiColor(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
