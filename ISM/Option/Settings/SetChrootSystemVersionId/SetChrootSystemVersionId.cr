module ISM

    module Option

        class Settings

            class SetChrootSystemVersionId < CommandLine::Option

                module Default

                    ShortText = "-scsvi"
                    LongText = "setchrootsystemversionid"
                    Description = "Set the system version ID of the future chroot installed system"
                    SetText = "Setting chroot system version ID to the value "

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
                        Ism.settings.setChrootSystemVersionId(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
