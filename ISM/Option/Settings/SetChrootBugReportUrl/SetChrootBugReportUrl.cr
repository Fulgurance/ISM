module ISM

    module Option

        class SettingsSetChrootBugReportUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootBugReportUrl::ShortText,
                        ISM::Default::Option::SettingsSetChrootBugReportUrl::LongText,
                        ISM::Default::Option::SettingsSetChrootBugReportUrl::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setChrootBugReportUrl(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootBugReportUrl::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
