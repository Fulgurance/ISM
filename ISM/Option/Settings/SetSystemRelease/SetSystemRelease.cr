module ISM

    module Option

        class SettingsSetSystemRelease < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemRelease::ShortText,
                        ISM::Default::Option::SettingsSetSystemRelease::LongText,
                        ISM::Default::Option::SettingsSetSystemRelease::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemRelease(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetSystemRelease::SetText+ARGV[2])
                end
            end

        end
        
    end

end
