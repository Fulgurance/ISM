module ISM

    module Option

        class Settings

            class SetChrootBuildId < CommandLine::Option

                module Default

                    ShortText = "-scbi"
                    LongText = "setchrootbuildid"
                    Description = "Set the build id of the future chroot installed system"
                    SetText = "Setting chroot system build id to the value "

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
                        Ism.settings.setChrootBuildId(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
