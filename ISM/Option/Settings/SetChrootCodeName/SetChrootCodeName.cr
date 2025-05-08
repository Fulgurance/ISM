module ISM

    module Option

        class SettingsSetChrootCodeName < ISM::CommandLineOption

            module Default
                ShortText = "-sccn"
                LongText = "setchrootcodename"
                Description = "Set the code name of the future chroot installed system"
                SetText = "Setting chroot system code name to the value "
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
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootCodeName(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
