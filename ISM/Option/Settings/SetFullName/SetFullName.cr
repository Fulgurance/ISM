module ISM

    module Option

        class SettingsSetFullName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetFullName::ShortText,
                        ISM::Default::Option::SettingsSetFullName::LongText,
                        ISM::Default::Option::SettingsSetFullName::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setFullName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetFullName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
