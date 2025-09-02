module ISM

    module Option

        class Settings

            class SetChrootTargetOs < ISM::CommandLineOption

                module Default

                    ShortText = "-scto"
                    LongText = "setchroottargetos"
                    Description = "Set the default chroot machine target OS for the compiler"
                    SetText = "Setting chroot target OS to the value "

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
                        Ism.settings.setChrootTargetOs(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
