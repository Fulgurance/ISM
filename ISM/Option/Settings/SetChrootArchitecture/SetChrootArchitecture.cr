module ISM

    module Option

        class SettingsSetChrootArchitecture < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootArchitecture::ShortText,
                        ISM::Default::Option::SettingsSetChrootArchitecture::LongText,
                        ISM::Default::Option::SettingsSetChrootArchitecture::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootArchitecture(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootArchitecture::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
