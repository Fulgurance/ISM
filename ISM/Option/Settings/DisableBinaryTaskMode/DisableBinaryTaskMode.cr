module ISM

    module Option

        class SettingsDisableBinaryTaskMode < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsDisableBinaryTaskMode::ShortText,
                        ISM::Default::Option::SettingsDisableBinaryTaskMode::LongText,
                        ISM::Default::Option::SettingsDisableBinaryTaskMode::Description)
            end

            def start
                if ARGV.size == 2
                    if !Ism.ranAsSuperUser
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setBinaryTaskMode(false)
                        Ism.printProcessNotification(ISM::Default::Option::SettingsDisableBinaryTaskMode::SetText)
                    end
                end
            end

        end
        
    end

end
