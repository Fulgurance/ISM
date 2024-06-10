module ISM

    module Option

        class SettingsSetDescription < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetDescription::ShortText,
                        ISM::Default::Option::SettingsSetDescription::LongText,
                        ISM::Default::Option::SettingsSetDescription::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setDescription(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetDescription::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
