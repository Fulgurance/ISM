module ISM

    module Option

        class Settings

            class SetChrootSystemFullName < CommandLine::Option

                module Default

                    ShortText = "-scsfn"
                    LongText = "setchrootsystemfullname"
                    Description = "Set the system full name of the future chroot installed system"
                    SetText = "Setting chroot system full name to the value "

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
                        Ism.settings.setChrootSystemFullName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
