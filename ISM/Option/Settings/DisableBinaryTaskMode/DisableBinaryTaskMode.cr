module ISM

    module Option

        class SettingsDisableBinaryTaskMode < ISM::CommandLineOption

            module Default
                ShortText = "-dbtm"
                LongText = "disablebinarytaskmode"
                Description = "Disable compilation for ism tasks. Task will be interpreted and will start directly, but speed process will be slower."
                SetText = "Disable binary task mode"
            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setBinaryTaskMode(false)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end
            end

        end
        
    end

end
