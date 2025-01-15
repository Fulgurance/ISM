module ISM

    module Option

        class SettingsEnableBinaryTaskMode < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableBinaryTaskMode::ShortText,
                        ISM::Default::Option::SettingsEnableBinaryTaskMode::LongText,
                        ISM::Default::Option::SettingsEnableBinaryTaskMode::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setBinaryTaskMode(true)
                        Ism.printProcessNotification(ISM::Default::Option::SettingsEnableBinaryTaskMode::SetText)
                    end
                end
            end

        end
        
    end

end
