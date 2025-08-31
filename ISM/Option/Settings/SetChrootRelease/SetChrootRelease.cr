module ISM

    module Option

        class Settings

            class SetChrootRelease < ISM::CommandLineOption

                module Default

                    ShortText = "-scr"
                    LongText = "setchrootrelease"
                    Description = "Set the release of the future chroot installed system"
                    SetText = "Setting chroot system release to the value "

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
                        Ism.settings.setChrootRelease(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
