module ISM

    module Option

        class SettingsDisableInstallByChroot < ISM::CommandLineOption

            module Default
                ShortText = "-dibc"
                LongText = "disableinstallbychroot"
                Description = "Disable softwares install by chroot"
                SetText = "Disabling softwares install by chroot"
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
                        Ism.settings.setInstallByChroot(false)
                        Ism.printProcessNotification(Default::SetText)
                    end
                end
            end

        end
        
    end

end
