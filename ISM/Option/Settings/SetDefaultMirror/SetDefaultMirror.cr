module ISM

    module Option

        class SettingsSetDefaultMirror < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetDefaultMirror::ShortText,
                        ISM::Default::Option::SettingsSetDefaultMirror::LongText,
                        ISM::Default::Option::SettingsSetDefaultMirror::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setDefaultMirror(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetDefaultMirror::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
