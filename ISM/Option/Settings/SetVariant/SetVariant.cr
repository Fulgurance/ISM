module ISM

    module Option

        class SettingsSetVariant < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetVariant::ShortText,
                        ISM::Default::Option::SettingsSetVariant::LongText,
                        ISM::Default::Option::SettingsSetVariant::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setVariant(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetVariant::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
