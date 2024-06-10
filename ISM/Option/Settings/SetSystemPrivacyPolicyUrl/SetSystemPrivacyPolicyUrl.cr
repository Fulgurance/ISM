module ISM

    module Option

        class SettingsSetSystemPrivacyPolicyUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::ShortText,
                        ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::LongText,
                        ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        Ism.settings.setSystemPrivacyPolicyUrl(ARGV[2+Ism.debugLevel])
                        Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::SetText+ARGV[2+Ism.debugLevel])
                    end
                end
            end

        end
        
    end

end
