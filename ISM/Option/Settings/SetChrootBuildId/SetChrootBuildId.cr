module ISM

    module Option

        class SettingsSetChrootBuildId < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootBuildId::ShortText,
                        ISM::Default::Option::SettingsSetChrootBuildId::LongText,
                        ISM::Default::Option::SettingsSetChrootBuildId::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootBuildId(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootBuildId::SetText+ARGV[2])
                end
            end

        end
        
    end

end
