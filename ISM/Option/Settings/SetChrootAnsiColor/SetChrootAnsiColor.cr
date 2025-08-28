module ISM

    module Option

        class SettingsSetChrootAnsiColor < ISM::CommandLineOption

            module Default

                ShortText = "-scac"
                LongText = "setchrootansicolor"
                Description = "Set the ANSI color of the future chroot installed system"
                SetText = "Setting chroot system ANSI color to the value "

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
                    Ism.settings.setChrootAnsiColor(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
