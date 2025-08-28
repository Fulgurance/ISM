module ISM

    module Option

        class SettingsSetSystemCodeName < ISM::CommandLineOption

            module Default

                ShortText = "-sscn"
                LongText = "setsystemcodename"
                Description = "Set the code name of the future installed system"
                SetText = "Setting the system code name to the value "

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
                    Ism.settings.setSystemCodeName(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
