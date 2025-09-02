module ISM

    module Option

        class Settings

            class SetSystemTargetVendor < ISM::CommandLineOption

                module Default

                    ShortText = "-sstv"
                    LongText = "setsystemtargetvendor"
                    Description = "Set the default machine target vendor for the compiler"
                    SetText = "Setting system target vendor to the value "

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
                        Ism.settings.setSystemTargetVendor(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
