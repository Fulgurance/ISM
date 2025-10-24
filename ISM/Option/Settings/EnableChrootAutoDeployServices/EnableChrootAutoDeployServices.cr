module ISM

    module Option

        class Settings

            class EnableChrootAutoDeployServices < CommandLine::Option

                module Default

                    ShortText = "-ecads"
                    LongText = "enablechrootautodeployservices"
                    Description = "Enable service automatic deployement for the chroot"
                    SetText = "Enabling service automatic deployement for the chroot"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        Ism.settings.setChrootAutoDeployServices(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end

            end

        end
        
    end

end
