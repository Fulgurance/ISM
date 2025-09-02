module ISM

    module Option

        class Settings

            class SetChrootTargetAbi < ISM::CommandLineOption

                module Default

                    ShortText = "-scta"
                    LongText = "setchroottargetabi"
                    Description = "Set the default chroot machine target ABI for the compiler"
                    SetText = "Setting chroot target ABI to the value "

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
                        Ism.settings.setChrootTargetAbi(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
