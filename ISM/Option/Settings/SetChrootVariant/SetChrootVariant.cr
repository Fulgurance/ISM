module ISM

    module Option

        class Settings

            class SetChrootVariant < ISM::CommandLineOption

                module Default

                    ShortText = "-scv"
                    LongText = "setchrootvariant"
                    Description = "Set the variant of the future chroot installed system"
                    SetText = "Setting chroot system variant to the value "

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
                        Ism.settings.setChrootVariant(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
