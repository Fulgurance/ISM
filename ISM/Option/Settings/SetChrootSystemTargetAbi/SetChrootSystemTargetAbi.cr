module ISM

    module Option

        class Settings

            class SetChrootSystemTargetAbi < CommandLine::Option

                module Default

                    ShortText = "-scsta"
                    LongText = "setchrootsystemtargetabi"
                    Description = "Set the default chroot system target ABI for the compiler"
                    SetText = "Setting chroot system target ABI to the value "

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
                        Ism.settings.setChrootSystemTargetAbi(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
