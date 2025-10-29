module ISM

    module Option

        class Settings

            class DisableAutoDeployServices < CommandLine::Option

                module Default

                    ShortText = "-dads"
                    LongText = "disableautodeployservices"
                    Description = "Disable service automatic deployement for the system"
                    SetText = "Disabling service automatic deployement for the system"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setAutoDeployServices(false)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
