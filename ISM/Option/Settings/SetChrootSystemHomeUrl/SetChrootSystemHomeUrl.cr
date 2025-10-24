module ISM

    module Option

        class Settings

            class SetChrootSystemHomeUrl < CommandLine::Option

                module Default

                    ShortText = "-scshu"
                    LongText = "setchrootsystemhomeurl"
                    Description = "Set the system home url of the future chroot installed system"
                    SetText = "Setting the chroot system home url to the value "

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
                        Ism.settings.setChrootSystemHomeUrl(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
