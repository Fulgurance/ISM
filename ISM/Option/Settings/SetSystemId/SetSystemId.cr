module ISM

    module Option

        class SettingsSetSystemId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemId::ShortText,
                        ISM::Default::Option::SettingsSetSystemId::LongText,
                        ISM::Default::Option::SettingsSetSystemId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemId(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemId::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
