module ISM

    module Option

        class SettingsSetSystemVariant < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemVariant::ShortText,
                        ISM::Default::Option::SettingsSetSystemVariant::LongText,
                        ISM::Default::Option::SettingsSetSystemVariant::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemVariant(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemVariant::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
