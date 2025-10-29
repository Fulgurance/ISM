module ISM

    module Option

        class Settings

            class DisableBuildKernelOptionsAsModule < CommandLine::Option

                module Default

                    ShortText = "-dbkoam"
                    LongText = "disablebuildkerneloptionsasmodule"
                    Description = "Disable the building of the kernel options as loadable modules as a priority for the system"
                    SetText = "Disabling building kernel options as module as a priority for the system"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setBuildKernelOptionsAsModule(false)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
