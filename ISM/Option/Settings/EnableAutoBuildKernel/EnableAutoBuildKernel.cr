module ISM

    module Option

        class Settings

            class EnableAutoBuildKernel < ISM::CommandLineOption

                module Default

                    ShortText = "-eabk"
                    LongText = "enableautobuildkernel"
                    Description = "Enable automatic kernel building"
                    SetText = "Enabling automatic kernel building"

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
