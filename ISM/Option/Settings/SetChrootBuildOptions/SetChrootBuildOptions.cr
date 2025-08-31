module ISM

    module Option

        class Settings

            class SetChrootBuildOptions < ISM::CommandLineOption

                module Default

                    ShortText = "-scbo"
                    LongText = "setchrootbuildoptions"
                    Description = "Set the default chroot CPU flags for the compiler"
                    SetText = "Setting chroot buildOptions to the value "

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
                        Ism.settings.setChrootBuildOptions(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
