module ISM

    module Option

        class Settings

            class SetChrootVersion < ISM::CommandLineOption

                module Default

                    ShortText = "-scv"
                    LongText = "setchrootversion"
                    Description = "Set the version of the future chroot installed system"
                    SetText = "Setting chroot system version to the value "

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
                        Ism.settings.setChrootVersion(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
