module ISM

    module Option

        class Settings

            class SetChrootSystemId < CommandLine::Option

                module Default

                    ShortText = "-scsi"
                    LongText = "setchrootsystemid"
                    Description = "Set the system id of the future chroot installed system"
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
                        Ism.settings.setChrootSystemId(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
