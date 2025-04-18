module ISM

    module Option

        class SettingsSetSystemVariantId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemVariantId::ShortText,
                        ISM::Default::Option::SettingsSetSystemVariantId::LongText,
                        ISM::Default::Option::SettingsSetSystemVariantId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemVariantId(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemVariantId::SetText+ARGV[2])
                end
            end

        end
        
    end

end
