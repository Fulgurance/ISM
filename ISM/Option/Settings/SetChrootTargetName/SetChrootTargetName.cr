module ISM

    module Option

        class SettingsSetChrootTargetName < ISM::CommandLineOption

            module Default

                ShortText = "-sctn"
                LongText = "setchroottargetname"
                Description = "Set the default chroot machine target for the compiler"
                SetText = "Setting chroot targetName to the value "

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
                    Ism.settings.setChrootTargetName(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
