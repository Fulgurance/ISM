module ISM

    module Option

        class Settings

            class SetChrootSupportUrl < CommandLine::Option

                module Default

                    ShortText = "-scsu"
                    LongText = "setchrootsupporturl"
                    Description = "Set the support url of the future chroot installed system"
                    SetText = "Setting the chroot system support url to the value "

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        showHelp
                    else
                        Ism.settings.setChrootSupportUrl(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
