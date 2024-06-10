module ISM

    module Option

        class SettingsSetChrootDescription < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootDescription::ShortText,
                        ISM::Default::Option::SettingsSetChrootDescription::LongText,
                        ISM::Default::Option::SettingsSetChrootDescription::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootDescription(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootDescription::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
