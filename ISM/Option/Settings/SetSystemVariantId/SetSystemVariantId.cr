module ISM

    module Option

        class Settings

            class SetSystemVariantId < ISM::CommandLineOption

                module Default

                    ShortText = "-ssvi"
                    LongText = "setsystemvariantid"
                    Description = "Set the variant id of the future installed system"
                    SetText = "Setting the system variant id to the value "

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
                        Ism.settings.setSystemVariantId(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
