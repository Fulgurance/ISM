module ISM

    module Option

        class Settings

            class DisableBuildKernelOptionsAsModule < ISM::CommandLineOption

                module Default

                    ShortText = "-dbkoam"
                    LongText = "disablebuildkerneloptionsasmodule"
                    Description = "Disable the building of the kernel options as loadable modules as a priority"
                    SetText = "Disabling building kernel options as module as a priority"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setBuildKernelOptionsAsModule(false)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end
        
    end

end
