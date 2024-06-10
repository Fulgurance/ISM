module ISM

    module Option

        class SettingsSetBuildId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetBuildId::ShortText,
                        ISM::Default::Option::SettingsSetBuildId::LongText,
                        ISM::Default::Option::SettingsSetBuildId::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setBuildId(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetBuildId::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
