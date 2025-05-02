module ISM

    module Option

        class SettingsSetChrootHomeUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootHomeUrl::ShortText,
                        ISM::Default::Option::SettingsSetChrootHomeUrl::LongText,
                        ISM::Default::Option::SettingsSetChrootHomeUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootHomeUrl(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootHomeUrl::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
