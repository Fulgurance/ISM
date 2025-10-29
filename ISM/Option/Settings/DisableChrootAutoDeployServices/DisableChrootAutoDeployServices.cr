module ISM

    module Option

        class Settings

            class DisableChrootAutoDeployServices < CommandLine::Option

                module Default

                    ShortText = "-dcads"
                    LongText = "disablechrootautodeployservices"
                    Description = "Disable service automatic deployement for the chroot"
                    SetText = "Disabling service automatic deployement for the chroot"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setChrootAutoDeployServices(false)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
