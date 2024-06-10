module ISM

    module Option

        class SettingsSetSystemMakeOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemMakeOptions::ShortText,
                        ISM::Default::Option::SettingsSetSystemMakeOptions::LongText,
                        ISM::Default::Option::SettingsSetSystemMakeOptions::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemMakeOptions(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemMakeOptions::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
