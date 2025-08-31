module ISM

    module Option

        class Settings

            class SetSystemVersionId < ISM::CommandLineOption

                module Default

                    ShortText = "-ssvi"
                    LongText = "setsystemversionid"
                    Description = "Set the version ID of the future installed system"
                    SetText = "Setting the system version ID to the value "

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
                        Ism.settings.setSystemVersion(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
