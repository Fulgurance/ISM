module ISM

    module Option

        class SettingsSetChrootRelease < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootRelease::ShortText,
                        ISM::Default::Option::SettingsSetChrootRelease::LongText,
                        ISM::Default::Option::SettingsSetChrootRelease::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setChrootRelease(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootRelease::SetText+ARGV[2])
                end
            end

        end
        
    end

end
