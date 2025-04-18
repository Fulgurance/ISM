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
                    Ism.settings.setBinaryTaskMode(true)
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsEnableBinaryTaskMode::SetText)
                end
            end

        end

    end

end
