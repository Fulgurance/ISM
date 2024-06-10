module ISM

    module Option

        class SettingsSetHomeUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetHomeUrl::ShortText,
                        ISM::Default::Option::SettingsSetHomeUrl::LongText,
                        ISM::Default::Option::SettingsSetHomeUrl::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setHomeUrl(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetHomeUrl::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
