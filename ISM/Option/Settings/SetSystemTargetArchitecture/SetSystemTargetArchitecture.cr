module ISM

    module Option

        class Settings

            class SetSystemTargetArchitecture < ISM::CommandLineOption

                module Default

                    ShortText = "-sstar"
                    LongText = "setsystemtargetarchitecture"
                    Description = "Set the default system target architecture for the compiler"
                    SetText = "Setting system target architecture to the value "

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
                        Ism.settings.setSystemTargetArchitecture(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
