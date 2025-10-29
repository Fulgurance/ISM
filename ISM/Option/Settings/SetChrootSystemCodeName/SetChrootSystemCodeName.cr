module ISM

    module Option

        class Settings

            class SetChrootSystemCodeName < CommandLine::Option

                module Default

                    ShortText = "-scscn"
                    LongText = "setchrootsystemcodename"
                    Description = "Set the system code name of the future chroot installed system"
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
                        Ism.settings.setChrootSystemCodeName(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
