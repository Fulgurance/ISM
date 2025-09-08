module ISM

    module Option

        class Settings

            class SetSystemVariant < CommandLine::Option

                module Default

                    ShortText = "-ssv"
                    LongText = "setsystemvariant"
                    Description = "Set the variant of the future installed system"
                    SetText = "Setting the system variant to the value "

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
                        Ism.settings.setSystemVariant(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
