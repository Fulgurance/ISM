module ISM

    module Option

        class SettingsDisableSecureMode < ISM::CommandLineOption

            module Default
                ShortText = "-dsm"
                LongText = "disablesecuremode"
                Description = "Disable the secure mode which requires superuser rights"
                SetText = "Disabling secure mode"
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
                        Ism.settings.setSecureMode(false)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end
            end

        end
        
    end

end
