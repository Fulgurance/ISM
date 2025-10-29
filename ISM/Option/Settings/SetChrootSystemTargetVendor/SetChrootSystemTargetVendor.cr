module ISM

    module Option

        class Settings

            class SetChrootSystemTargetVendor < CommandLine::Option

                module Default

                    ShortText = "-scstv"
                    LongText = "setchrootsystemtargetvendor"
                    Description = "Set the default chroot system target vendor for the compiler"
                    SetText = "Setting chroot system target vendor to the value "

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
                        Ism.settings.setChrootSystemTargetVendor(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
