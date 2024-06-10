module ISM

    module Option

        class SettingsSetVersion < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetVersion::ShortText,
                        ISM::Default::Option::SettingsSetVersion::LongText,
                        ISM::Default::Option::SettingsSetVersion::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setVersion(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetVersion::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
