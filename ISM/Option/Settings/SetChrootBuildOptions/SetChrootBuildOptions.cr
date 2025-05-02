module ISM

    module Option

        class SettingsSetChrootBuildOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootBuildOptions::ShortText,
                        ISM::Default::Option::SettingsSetChrootBuildOptions::LongText,
                        ISM::Default::Option::SettingsSetChrootBuildOptions::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootBuildOptions(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootBuildOptions::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
