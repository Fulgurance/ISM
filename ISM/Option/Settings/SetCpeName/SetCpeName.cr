module ISM

    module Option

        class SettingsSetCpeName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetCpeName::ShortText,
                        ISM::Default::Option::SettingsSetCpeName::LongText,
                        ISM::Default::Option::SettingsSetCpeName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setCpeName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetCpeName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
