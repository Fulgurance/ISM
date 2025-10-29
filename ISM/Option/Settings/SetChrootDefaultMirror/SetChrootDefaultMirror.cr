module ISM

    module Option

        class Settings

            class SetChrootDefaultMirror < CommandLine::Option

                module Default

                    ShortText = "-scdm"
                    LongText = "setchrootdefaultmirror"
                    Description = "Set the default mirror for the chroot"
                    SetText = "Setting the default mirror for the chroot to "

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
                        Ism.settings.setChrootDefaultMirror(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
