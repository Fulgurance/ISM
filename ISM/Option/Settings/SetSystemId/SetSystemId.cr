module ISM

    module Option

        class Settings

            class SetSystemId < ISM::CommandLineOption

                module Default

                    ShortText = "-ssi"
                    LongText = "setsystemid"
                    Description = "Set the id of the future installed system"
                    SetText = "Setting the system id to the value "

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
                        Ism.settings.setSystemId(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
