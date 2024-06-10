module ISM

    module Option

        class SettingsSetName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetName::ShortText,
                        ISM::Default::Option::SettingsSetName::LongText,
                        ISM::Default::Option::SettingsSetName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
