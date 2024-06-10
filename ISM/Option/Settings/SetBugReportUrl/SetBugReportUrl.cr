module ISM

    module Option

        class SettingsSetBugReportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetBugReportUrl::ShortText,
                        ISM::Default::Option::SettingsSetBugReportUrl::LongText,
                        ISM::Default::Option::SettingsSetBugReportUrl::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setBugReportUrl(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetBugReportUrl::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
