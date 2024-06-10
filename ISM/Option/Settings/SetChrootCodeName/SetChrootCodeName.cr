module ISM

    module Option

        class SettingsSetChrootCodeName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootCodeName::ShortText,
                        ISM::Default::Option::SettingsSetChrootCodeName::LongText,
                        ISM::Default::Option::SettingsSetChrootCodeName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootCodeName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootCodeName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
