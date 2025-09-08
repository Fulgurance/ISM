module ISM

    module Option

        class Settings

            class SetChrootMakeOptions < CommandLine::Option

                module Default

                    ShortText = "-scmo"
                    LongText = "setchrootmakeoptions"
                    Description = "Set the default chroot parallel make jobs number for the compiler"
                    SetText = "Setting chroot makeOptions to the value "

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
                        Ism.settings.setChrootMakeOptions(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
