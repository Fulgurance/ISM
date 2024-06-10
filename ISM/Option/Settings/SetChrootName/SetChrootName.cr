module ISM

    module Option

        class SettingsSetChrootName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootName::ShortText,
                        ISM::Default::Option::SettingsSetChrootName::LongText,
                        ISM::Default::Option::SettingsSetChrootName::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
