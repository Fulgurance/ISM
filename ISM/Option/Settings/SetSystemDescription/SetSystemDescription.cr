module ISM

    module Option

        class SettingsSetSystemDescription < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemDescription::ShortText,
                        ISM::Default::Option::SettingsSetSystemDescription::LongText,
                        ISM::Default::Option::SettingsSetSystemDescription::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemDescription(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemDescription::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
