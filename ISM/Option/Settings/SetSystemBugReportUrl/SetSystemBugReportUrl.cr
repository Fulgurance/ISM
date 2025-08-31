module ISM

    module Option

        class Settings

            class SetSystemBugReportUrl < ISM::CommandLineOption

                module Default

                    ShortText = "-ssbru"
                    LongText = "setsystembugreporturl"
                    Description = "Set the bug report url of the future installed system"
                    SetText = "Setting the system bug report url to the value "

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
                        Ism.settings.setSystemBugReportUrl(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
