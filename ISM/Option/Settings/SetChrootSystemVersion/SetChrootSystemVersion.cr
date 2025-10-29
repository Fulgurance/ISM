module ISM

    module Option

        class Settings

            class SetChrootSystemVersion < CommandLine::Option

                module Default

                    ShortText = "-scsv"
                    LongText = "setchrootsystemversion"
                    Description = "Set the system version of the future chroot installed system"
                    SetText = "Setting chroot system version to the value "

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
                        Ism.settings.setChrootSystemVersion(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
