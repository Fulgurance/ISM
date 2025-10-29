module ISM

    module Option

        class Settings

            class SetChrootSystemTargetArchitecture < CommandLine::Option

                module Default

                    ShortText = "-scstar"
                    LongText = "setchrootsystemtargetarchitecture"
                    Description = "Set the default chroot system target architecture for the compiler"
                    SetText = "Setting chroot system target architecture to the value "

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
                        Ism.settings.setChrootSystemTargetArchitecture(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
