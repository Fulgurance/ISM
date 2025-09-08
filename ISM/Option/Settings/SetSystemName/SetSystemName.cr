module ISM

    module Option

        class Settings

            class SetSystemName < CommandLine::Option

                module Default

                    ShortText = "-ssn"
                    LongText = "setsystemname"
                    Description = "Set the name of the future installed system"
                    SetText = "Setting system name to the value "

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
                        Ism.settings.setSystemName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
