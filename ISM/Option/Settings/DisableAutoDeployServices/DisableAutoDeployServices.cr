module ISM

    module Option

        class Settings

            class DisableAutoDeployServices < CommandLine::Option

                module Default

                    ShortText = "-dads"
                    LongText = "disableautodeployservices"
                    Description = "Disable service automatic deployement"
                    SetText = "Disabling service automatic deployement"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setAutoDeployServices(false)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end
        
    end

end
