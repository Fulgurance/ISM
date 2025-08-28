module ISM

    module Option

        class SettingsSetSystemPrivacyPolicyUrl < ISM::CommandLineOption

            module Default

                ShortText = "-ssppu"
                LongText = "setsystemprivacypolicyurl"
                Description = "Set the privacy policy url of the future installed system"
                SetText = "Setting the system privacy policy url to the value "

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemPrivacyPolicyUrl(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
