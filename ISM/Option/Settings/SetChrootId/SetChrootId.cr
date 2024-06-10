module ISM

    module Option

        class SettingsSetChrootId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootId::ShortText,
                        ISM::Default::Option::SettingsSetChrootId::LongText,
                        ISM::Default::Option::SettingsSetChrootId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
