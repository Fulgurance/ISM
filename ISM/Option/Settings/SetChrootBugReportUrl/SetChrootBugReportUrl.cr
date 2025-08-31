module ISM

    module Option

        class Settings

            class SetChrootBugReportUrl < ISM::CommandLineOption

                module Default

                    ShortText = "-scbru"
                    LongText = "setchrootbugreporturl"
                    Description = "Set the bug report url of the future chroot installed system"
                    SetText = "Setting the chroot system bug report url to the value "

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
                        Ism.settings.setChrootBugReportUrl(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
