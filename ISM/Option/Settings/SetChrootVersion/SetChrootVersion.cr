module ISM

    module Option

        class SettingsSetChrootVersion < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootVersion::ShortText,
                        ISM::Default::Option::SettingsSetChrootVersion::LongText,
                        ISM::Default::Option::SettingsSetChrootVersion::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootVersion(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootVersion::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
