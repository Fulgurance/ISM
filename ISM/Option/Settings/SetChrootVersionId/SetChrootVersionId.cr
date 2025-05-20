module ISM

    module Option

        class SettingsSetChrootVersionId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootVersionId::ShortText,
                        ISM::Default::Option::SettingsSetChrootVersionId::LongText,
                        ISM::Default::Option::SettingsSetChrootVersionId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootVersionId(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootVersionId::SetText+ARGV[2])
                end
            end

        end
        
    end

end
