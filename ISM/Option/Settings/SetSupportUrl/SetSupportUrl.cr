module ISM

    module Option

        class SettingsSetSupportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSupportUrl::ShortText,
                        ISM::Default::Option::SettingsSetSupportUrl::LongText,
                        ISM::Default::Option::SettingsSetSupportUrl::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSupportUrl(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSupportUrl::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
