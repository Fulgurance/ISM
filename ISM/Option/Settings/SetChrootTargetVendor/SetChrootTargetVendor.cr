module ISM

    module Option

        class Settings

            class SetChrootTargetVendor < CommandLine::Option

                module Default

                    ShortText = "-sctv"
                    LongText = "setchroottargetvendor"
                    Description = "Set the default chroot machine target vendor for the compiler"
                    SetText = "Setting chroot target vendor to the value "

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
                        Ism.settings.setChrootTargetVendor(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
