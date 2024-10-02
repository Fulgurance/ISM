module ISM

    module Option

        class SettingsSetSystemSupportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemSupportUrl::ShortText,
                        ISM::Default::Option::SettingsSetSystemSupportUrl::LongText,
                        ISM::Default::Option::SettingsSetSystemSupportUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemSupportUrl(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemSupportUrl::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
