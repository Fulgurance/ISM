module ISM

    module Option

        class SettingsSetChrootBugReportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootBugReportUrl::ShortText,
                        ISM::Default::Option::SettingsSetChrootBugReportUrl::LongText,
                        ISM::Default::Option::SettingsSetChrootBugReportUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootBugReportUrl(ARGV[2])
                    ISM::Core::Notification.processNotification(ISM::Default::Option::SettingsSetChrootBugReportUrl::SetText+ARGV[2])
                end
            end

        end
        
    end

end
