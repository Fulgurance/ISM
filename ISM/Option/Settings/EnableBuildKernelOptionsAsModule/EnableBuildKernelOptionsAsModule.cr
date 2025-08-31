module ISM

    module Option

        class Settings

            class EnableBuildKernelOptionsAsModule < ISM::CommandLineOption

                module Default

                    ShortText = "-ebkoam"
                    LongText = "enablebuildkerneloptionsasmodule"
                    Description = "Enable the building of the kernel options as loadable modules as a priority"
                    SetText = "Enabling building kernel options as module as a priority"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setBuildKernelOptionsAsModule(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end
        
    end

end
