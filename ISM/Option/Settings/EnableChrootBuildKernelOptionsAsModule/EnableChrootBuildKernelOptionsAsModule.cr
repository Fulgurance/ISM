module ISM

    module Option

        class Settings

            class EnableChrootBuildKernelOptionsAsModule < CommandLine::Option

                module Default

                    ShortText = "-ecbkoam"
                    LongText = "enablechrootbuildkerneloptionsasmodule"
                    Description = "Enable the building of the kernel options as loadable modules as a priority for the chroot"
                    SetText = "Enabling building kernel options as module as a priority for the chroot"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setChrootBuildKernelOptionsAsModule(true)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
