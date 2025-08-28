module ISM

    module Option

        class SettingsSetChrootDescription < ISM::CommandLineOption

            module Default

                ShortText = "-scd"
                LongText = "setchrootdescription"
                Description = "Set the description of the future chroot installed system"
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
                    Ism.settings.setChrootDescription(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
