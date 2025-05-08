module ISM

    module Option

        class SettingsEnableSecureMode < ISM::CommandLineOption

            module Default
                ShortText = "-esm"
                LongText = "enablesecuremode"
                Description = "Enable the secure mode which requires superuser rights"
                SetText = "Enabling secure mode"
            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSecureMode(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end
            end

        end
        
    end

end
