module ISM

    module Option

        class SettingsSetChrootName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootName::ShortText,
                        ISM::Default::Option::SettingsSetChrootName::LongText,
                        ISM::Default::Option::SettingsSetChrootName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootName(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
