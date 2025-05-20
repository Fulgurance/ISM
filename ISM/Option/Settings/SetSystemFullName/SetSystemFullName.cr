module ISM

    module Option

        class SettingsSetSystemFullName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemFullName::ShortText,
                        ISM::Default::Option::SettingsSetSystemFullName::LongText,
                        ISM::Default::Option::SettingsSetSystemFullName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemFullName(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemFullName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
