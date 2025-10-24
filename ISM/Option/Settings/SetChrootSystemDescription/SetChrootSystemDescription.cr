module ISM

    module Option

        class Settings

            class SetChrootSystemDescription < CommandLine::Option

                module Default

                    ShortText = "-scsd"
                    LongText = "setchrootsystemdescription"
                    Description = "Set the system description of the future chroot installed system"
                    SetText = "Setting chroot system description to the value "

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
                        Ism.settings.setChrootSystemDescription(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
