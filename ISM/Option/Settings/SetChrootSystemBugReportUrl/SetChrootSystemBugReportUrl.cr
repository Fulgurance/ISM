module ISM

    module Option

        class Settings

            class SetChrootSystemBugReportUrl < CommandLine::Option

                module Default

                    ShortText = "-scsbru"
                    LongText = "setchrootsystembugreporturl"
                    Description = "Set the system bug report url of the future chroot installed system"
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
                        Ism.settings.setChrootSystemBugReportUrl(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
