module ISM

    module Option

        class SettingsSetChrootFullName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootFullName::ShortText,
                        ISM::Default::Option::SettingsSetChrootFullName::LongText,
                        ISM::Default::Option::SettingsSetChrootFullName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootFullName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootFullName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
