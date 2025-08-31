module ISM

    module Option

        class Settings

            class SetSystemDescription < ISM::CommandLineOption

                module Default

                    ShortText = "-ssd"
                    LongText = "setsystemdescription"
                    Description = "Set the description of the future installed system"
                    SetText = "Setting the system description to the value "

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
                        Ism.settings.setSystemDescription(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
