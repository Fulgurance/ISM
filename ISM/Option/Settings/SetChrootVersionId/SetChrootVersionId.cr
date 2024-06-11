module ISM

    module Option

        class SettingsSetChrootVersionId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootVersionId::ShortText,
                        ISM::Default::Option::SettingsSetChrootVersionId::LongText,
                        ISM::Default::Option::SettingsSetChrootVersionId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootVersionId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootVersionId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
