module ISM

    module Option

        class SettingsSetChrootAnsiColor < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootAnsiColor::ShortText,
                        ISM::Default::Option::SettingsSetChrootAnsiColor::LongText,
                        ISM::Default::Option::SettingsSetChrootAnsiColor::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootAnsiColor(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootAnsiColor::SetText+ARGV[2])
                end
            end

        end
        
    end

end
