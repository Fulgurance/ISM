module ISM

    module Option

        class SettingsSetSystemPrivacyPolicyUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::ShortText,
                        ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::LongText,
                        ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemPrivacyPolicyUrl(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemPrivacyPolicyUrl::SetText+ARGV[2])
                end
            end

        end
        
    end

end
