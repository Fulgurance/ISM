module ISM

    module Option

        class SettingsSetSystemArchitecture < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemArchitecture::ShortText,
                        ISM::Default::Option::SettingsSetSystemArchitecture::LongText,
                        ISM::Default::Option::SettingsSetSystemArchitecture::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemArchitecture(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemArchitecture::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
