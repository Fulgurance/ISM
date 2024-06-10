module ISM

    module Option

        class SettingsSetArchitecture < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetArchitecture::ShortText,
                        ISM::Default::Option::SettingsSetArchitecture::LongText,
                        ISM::Default::Option::SettingsSetArchitecture::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setArchitecture(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetArchitecture::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
