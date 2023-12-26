module ISM

    module Option

        class SettingsSetTargetName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetTargetName::ShortText,
                        ISM::Default::Option::SettingsSetTargetName::LongText,
                        ISM::Default::Option::SettingsSetTargetName::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setTargetName(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetTargetName::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
