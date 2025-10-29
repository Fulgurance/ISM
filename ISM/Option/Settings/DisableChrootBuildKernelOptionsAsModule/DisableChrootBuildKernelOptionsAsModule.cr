module ISM

    module Option

        class Settings

            class DisableChrootBuildKernelOptionsAsModule < CommandLine::Option

                module Default

                    ShortText = "-dcbkoam"
                    LongText = "disablechrootbuildkerneloptionsasmodule"
                    Description = "Disable the building of the kernel options as loadable modules as a priority for the chroot"
                    SetText = "Disabling building kernel options as module as a priority for the chroot"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setChrootBuildKernelOptionsAsModule(false)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
