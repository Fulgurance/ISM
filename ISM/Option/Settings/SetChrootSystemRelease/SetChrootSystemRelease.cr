module ISM

    module Option

        class Settings

            class SetChrootSystemRelease < CommandLine::Option

                module Default

                    ShortText = "-scr"
                    LongText = "setchrootsystemrelease"
                    Description = "Set the system release of the future chroot installed system"
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
                        Ism.settings.setChrootSystemRelease(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
