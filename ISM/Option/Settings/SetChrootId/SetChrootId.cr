module ISM

    module Option

        class Settings

            class SetChrootId < CommandLine::Option

                module Default

                    ShortText = "-sci"
                    LongText = "setchrootid"
                    Description = "Set the id of the future chroot installed system"
                    SetText = "Setting chroot system id to the value "

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
                        Ism.settings.setChrootId(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
