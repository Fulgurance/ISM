module ISM

    module Option

        class SettingsSetSystemHomeUrl < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemHomeUrl::ShortText,
                        ISM::Default::Option::SettingsSetSystemHomeUrl::LongText,
                        ISM::Default::Option::SettingsSetSystemHomeUrl::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemHomeUrl(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemHomeUrl::SetText+ARGV[2])
                end
            end

        end
        
    end

end
