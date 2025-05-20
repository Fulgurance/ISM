module ISM

    module Option

        class SettingsSetChrootDescription < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootDescription::ShortText,
                        ISM::Default::Option::SettingsSetChrootDescription::LongText,
                        ISM::Default::Option::SettingsSetChrootDescription::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootDescription(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootDescription::SetText+ARGV[2])
                end
            end

        end
        
    end

end
