module ISM

    module Option

        class Settings

            class SetDefaultMirror < CommandLine::Option

                module Default

                    ShortText = "-sdm"
                    LongText = "setdefaultmirror"
                    Description = "Set the default mirror for the system"
                    SetText = "Setting the default mirror for the system to "

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
                        Ism.settings.setDefaultMirror(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
