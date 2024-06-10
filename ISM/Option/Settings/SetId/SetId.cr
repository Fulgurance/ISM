module ISM

    module Option

        class SettingsSetId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetId::ShortText,
                        ISM::Default::Option::SettingsSetId::LongText,
                        ISM::Default::Option::SettingsSetId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
