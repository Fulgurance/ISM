module ISM

    module Option

        class SettingsEnableInstallByChroot < ISM::CommandLineOption

            module Default
                ShortText = "-eibc"
                LongText = "enableinstallbychroot"
                Description = "Enable softwares install by chroot"
                SetText = "Enabling softwares install by chroot"
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
                        Ism.settings.setInstallByChroot(true)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end
            end

        end
        
    end

end
