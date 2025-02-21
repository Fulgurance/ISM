module ISM

    module Option

        class SettingsSetSystemBugReportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemBugReportUrl::ShortText,
                        ISM::Default::Option::SettingsSetSystemBugReportUrl::LongText,
                        ISM::Default::Option::SettingsSetSystemBugReportUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemBugReportUrl(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemBugReportUrl::SetText+ARGV[2])
                end
            end

        end
        
    end

end
