module ISM

    module Option

        class SettingsSetSystemVersion < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemVersion::ShortText,
                        ISM::Default::Option::SettingsSetSystemVersion::LongText,
                        ISM::Default::Option::SettingsSetSystemVersion::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemVersion(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemVersion::SetText+ARGV[2])
                end
            end

        end
        
    end

end
