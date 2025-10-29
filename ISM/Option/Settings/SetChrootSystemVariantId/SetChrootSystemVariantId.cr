module ISM

    module Option

        class Settings

            class SetChrootSystemVariantId < CommandLine::Option

                module Default

                    ShortText = "-scsvi"
                    LongText = "setchrootsystemvariantid"
                    Description = "Set the system variant id of the future chroot installed system"
                    SetText = "Setting chroot system variant id to the value "

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
                        Ism.settings.setChrootSystemVariantId(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
