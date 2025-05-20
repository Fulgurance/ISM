module ISM

    module Option

        class SettingsSetChrootCpeName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootCpeName::ShortText,
                        ISM::Default::Option::SettingsSetChrootCpeName::LongText,
                        ISM::Default::Option::SettingsSetChrootCpeName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootCpeName(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootCpeName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
