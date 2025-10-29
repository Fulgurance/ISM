module ISM

    module Option

        class Settings

            class SetSystemCpeName < CommandLine::Option

                module Default

                    ShortText = "-sscpen"
                    LongText = "setsystemcpename"
                    Description = "Set the CPE name of the future installed system"
                    SetText = "Setting the system CPE name to the value "

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
                        Ism.settings.setSystemCpeName(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
