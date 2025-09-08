module ISM

    module Option

        class Settings

            class SetSystemTargetAbi < CommandLine::Option

                module Default

                    ShortText = "-ssta"
                    LongText = "setsystemtargetabi"
                    Description = "Set the default system target ABI for the compiler"
                    SetText = "Setting system target ABI to the value "

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
                        Ism.settings.setSystemTargetAbi(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
