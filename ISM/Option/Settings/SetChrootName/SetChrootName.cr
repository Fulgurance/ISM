module ISM

    module Option

        class Settings

            class SetChrootName < ISM::CommandLineOption

                module Default

                    ShortText = "-scn"
                    LongText = "setchrootname"
                    Description = "Set the name of the future chroot installed system"
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
                        Ism.settings.setChrootName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
