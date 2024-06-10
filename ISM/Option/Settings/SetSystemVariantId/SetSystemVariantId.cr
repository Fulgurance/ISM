module ISM

    module Option

        class SettingsSetSystemVariantId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemVariantId::ShortText,
                        ISM::Default::Option::SettingsSetSystemVariantId::LongText,
                        ISM::Default::Option::SettingsSetSystemVariantId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemVariantId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemVariantId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
