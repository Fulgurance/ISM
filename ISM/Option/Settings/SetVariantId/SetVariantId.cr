module ISM

    module Option

        class SettingsSetVariantId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetVariantId::ShortText,
                        ISM::Default::Option::SettingsSetVariantId::LongText,
                        ISM::Default::Option::SettingsSetVariantId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setVariantId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetVariantId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
