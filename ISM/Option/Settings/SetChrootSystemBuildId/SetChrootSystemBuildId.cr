module ISM

    module Option

        class Settings

            class SetChrootSystemBuildId < CommandLine::Option

                module Default

                    ShortText = "-scsbi"
                    LongText = "setchrootsystembuildid"
                    Description = "Set the system build id of the future chroot installed system"
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
                        Ism.settings.setChrootSystemBuildId(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
