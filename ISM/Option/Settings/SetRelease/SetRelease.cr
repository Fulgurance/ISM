module ISM

    module Option

        class SettingsSetRelease < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetRelease::ShortText,
                        ISM::Default::Option::SettingsSetRelease::LongText,
                        ISM::Default::Option::SettingsSetRelease::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setRelease(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetRelease::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
