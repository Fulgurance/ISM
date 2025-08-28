module ISM

    module Option

        class SettingsSetChrootHomeUrl < ISM::CommandLineOption

            module Default

                ShortText = "-schu"
                LongText = "setchroothomeurl"
                Description = "Set the home url of the future chroot installed system"
                SetText = "Setting the chroot system home url to the value "

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
                    Ism.settings.setChrootHomeUrl(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
