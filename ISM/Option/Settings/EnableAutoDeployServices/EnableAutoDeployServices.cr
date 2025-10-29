module ISM

    module Option

        class Settings

            class EnableAutoDeployServices < CommandLine::Option

                module Default

                    ShortText = "-eads"
                    LongText = "enableautodeployservices"
                    Description = "Enable service automatic deployement for the system"
                    SetText = "Enabling service automatic deployement for the system"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setAutoDeployServices(true)
                        ISM::Core::Notification.runningProcess(Default::SetText)
                    end
                end

            end

        end
        
    end

end
