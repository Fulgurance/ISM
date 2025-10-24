module ISM

    module Option

        class Settings

            class EnableChrootAutoBuildKernel < CommandLine::Option

                module Default

                    ShortText = "-ecabk"
                    LongText = "enablechrootautobuildkernel"
                    Description = "Enable automatic kernel building for the chroot"
                    SetText = "Enabling automatic kernel building for the chroot"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setChrootAutoBuildKernel(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end
        
    end

end
