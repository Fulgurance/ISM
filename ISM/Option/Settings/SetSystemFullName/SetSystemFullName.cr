module ISM

    module Option

        class Settings

            class SetSystemFullName < ISM::CommandLineOption

                module Default

                    ShortText = "-ssfn"
                    LongText = "setsystemfullname"
                    Description = "Set the full name of the future installed system"
                    SetText = "Setting the full system name to the value "

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
                        Ism.settings.setSystemFullName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
