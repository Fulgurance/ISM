module ISM

    module Option

        class SettingsSetCodeName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetCodeName::ShortText,
                        ISM::Default::Option::SettingsSetCodeName::LongText,
                        ISM::Default::Option::SettingsSetCodeName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setCodeName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetCodeName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
