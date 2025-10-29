module ISM

    module Option

        class Settings

            class SetChrootSystemTargetOs < CommandLine::Option

                module Default

                    ShortText = "-scsto"
                    LongText = "setchrootsystemtargetos"
                    Description = "Set the default chroot system target OS for the compiler"
                    SetText = "Setting chroot system target OS to the value "

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
                        Ism.settings.setChrootSystemTargetOs(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
