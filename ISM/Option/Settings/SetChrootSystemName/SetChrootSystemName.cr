module ISM

    module Option

        class Settings

            class SetChrootSystemName < CommandLine::Option

                module Default

                    ShortText = "-scsn"
                    LongText = "setchrootsystemname"
                    Description = "Set the system name of the future chroot installed system"
                    SetText = "Setting chroot system name to the value "

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
                        Ism.settings.setChrootSystemName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
