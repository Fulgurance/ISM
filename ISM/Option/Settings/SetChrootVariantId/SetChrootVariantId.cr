module ISM

    module Option

        class SettingsSetChrootVariantId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootVariantId::ShortText,
                        ISM::Default::Option::SettingsSetChrootVariantId::LongText,
                        ISM::Default::Option::SettingsSetChrootVariantId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootVariantId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootVariantId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
