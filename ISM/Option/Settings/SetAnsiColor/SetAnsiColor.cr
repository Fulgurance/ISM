module ISM

    module Option

        class SettingsSetAnsiColor < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetAnsiColor::ShortText,
                        ISM::Default::Option::SettingsSetAnsiColor::LongText,
                        ISM::Default::Option::SettingsSetAnsiColor::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setAnsiColor(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetAnsiColor::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
