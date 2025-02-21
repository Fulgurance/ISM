module ISM

    module Option

        class SettingsSetSystemCodeName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemCodeName::ShortText,
                        ISM::Default::Option::SettingsSetSystemCodeName::LongText,
                        ISM::Default::Option::SettingsSetSystemCodeName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemCodeName(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemCodeName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
