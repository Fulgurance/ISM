module ISM

    module Option

        class Settings

            class DisableAutoBuildKernel < CommandLine::Option

                module Default

                    ShortText = "-dabk"
                    LongText = "disableautobuildkernel"
                    Description = "Disable automatic kernel building for the system"
                    SetText = "Disabling automatic kernel building for the system"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setAutoBuildKernel(false)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
