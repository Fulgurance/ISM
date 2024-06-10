module ISM

    module Option

        class SettingsSetSystemFullName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemFullName::ShortText,
                        ISM::Default::Option::SettingsSetSystemFullName::LongText,
                        ISM::Default::Option::SettingsSetSystemFullName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemFullName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemFullName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
