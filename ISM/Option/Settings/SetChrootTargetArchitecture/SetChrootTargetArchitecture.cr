module ISM

    module Option

        class Settings

            class SetChrootTargetArchitecture < ISM::CommandLineOption

                module Default

                    ShortText = "-sctar"
                    LongText = "setchroottargetarchitecture"
                    Description = "Set the default chroot target architecture for the compiler"
                    SetText = "Setting chroot target architecture to the value "

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
                        Ism.settings.setChrootTargetArchitecture(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
