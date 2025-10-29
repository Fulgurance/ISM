module ISM

    module Option

        class Settings

            class SetChrootSystemVariant < CommandLine::Option

                module Default

                    ShortText = "-scsv"
                    LongText = "setchrootsystemvariant"
                    Description = "Set the system variant of the future chroot installed system"
                    SetText = "Setting chroot system variant to the value "

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
                        Ism.settings.setChrootSystemVariant(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
