module ISM

    module Option

        class Settings

            class DisableChrootAutoBuildKernel < CommandLine::Option

                module Default

                    ShortText = "-dcabk"
                    LongText = "disablechrootautobuildkernel"
                    Description = "Disable automatic kernel building for the chroot"
                    SetText = "Disabling automatic kernel building for the chroot"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setChrootAutoBuildKernel(false)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
