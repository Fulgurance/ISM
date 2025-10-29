module ISM

    module Option

        class Settings

            class SetSystemTargetOs < CommandLine::Option

                module Default

                    ShortText = "-ssto"
                    LongText = "setsystemtargetos"
                    Description = "Set the default system target OS for the compiler"
                    SetText = "Setting system target OS to the value "

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
                        Ism.settings.setSystemTargetOs(ARGV[2])
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
