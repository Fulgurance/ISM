module ISM

    module Option

        class Settings

            class EnableAutoBuildKernel < CommandLine::Option

                module Default

                    ShortText = "-eabk"
                    LongText = "enableautobuildkernel"
                    Description = "Enable automatic kernel building for the system"
                    SetText = "Enabling automatic kernel building for the system"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setAutoBuildKernel(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end
        
    end

end
