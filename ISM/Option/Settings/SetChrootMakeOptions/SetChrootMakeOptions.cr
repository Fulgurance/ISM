module ISM

    module Option

        class SettingsSetChrootMakeOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootMakeOptions::ShortText,
                        ISM::Default::Option::SettingsSetChrootMakeOptions::LongText,
                        ISM::Default::Option::SettingsSetChrootMakeOptions::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootMakeOptions(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootMakeOptions::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
