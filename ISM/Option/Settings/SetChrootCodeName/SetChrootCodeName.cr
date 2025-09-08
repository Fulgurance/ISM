module ISM

    module Option

        class Settings

            class SetChrootCodeName < CommandLine::Option

                module Default

                    ShortText = "-sccn"
                    LongText = "setchrootcodename"
                    Description = "Set the code name of the future chroot installed system"
                    SetText = "Setting chroot system code name to the value "

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
                        Ism.settings.setChrootCodeName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
