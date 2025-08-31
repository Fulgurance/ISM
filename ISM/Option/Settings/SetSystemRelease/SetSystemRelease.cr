module ISM

    module Option

        class Settings

            class SetSystemRelease < ISM::CommandLineOption

                module Default

                    ShortText = "-ssr"
                    LongText = "setsystemrelease"
                    Description = "Set the release of the future installed system"
                    SetText = "Setting the system release to the value "

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
                        Ism.settings.setSystemRelease(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
