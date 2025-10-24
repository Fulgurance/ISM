module ISM

    module Option

        class Settings

            class SetChrootSystemAnsiColor < CommandLine::Option

                module Default

                    ShortText = "-scsac"
                    LongText = "setchrootsystemansicolor"
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
                        Ism.settings.setChrootSystemAnsiColor(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
