module ISM

    module Option

        class SettingsSetSystemVersionId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemVersionId::ShortText,
                        ISM::Default::Option::SettingsSetSystemVersionId::LongText,
                        ISM::Default::Option::SettingsSetSystemVersionId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemVersion(ARGV[2])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemVersionId::SetText+ARGV[2])
                    end
                end
            end

        end
        
    end

end
