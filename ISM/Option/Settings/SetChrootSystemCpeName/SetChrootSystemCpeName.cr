module ISM

    module Option

        class Settings

            class SetChrootSystemCpeName < CommandLine::Option

                module Default

                    ShortText = "-scscpen"
                    LongText = "setchrootsystemcpename"
                    Description = "Set the system CPE name of the future chroot installed system"
                    SetText = "Setting chroot system CPE name to the value "

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
                        Ism.settings.setChrootSystemCpeName(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
