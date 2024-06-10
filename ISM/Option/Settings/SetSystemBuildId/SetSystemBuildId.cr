module ISM

    module Option

        class SettingsSetSystemBuildId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemBuildId::ShortText,
                        ISM::Default::Option::SettingsSetSystemBuildId::LongText,
                        ISM::Default::Option::SettingsSetSystemBuildId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemBuildId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemBuildId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
