module ISM

    module Option

        class Settings

            class SetSystemPrivacyPolicyUrl < CommandLine::Option

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
                        ISM::Core::Notification.runningProcess(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
