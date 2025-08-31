module ISM

    module Option

        class Settings

            class SetChrootArchitecture < ISM::CommandLineOption

                module Default

                    ShortText = "-sca"
                    LongText = "setchrootarchitecture"
                    Description = "Set the default chroot target architecture for the compiler"
                    SetText = "Setting chroot architecture to the value "

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
                        Ism.settings.setChrootArchitecture(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
