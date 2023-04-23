module ISM

    module Option

        class SettingsSetChrootBuildOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootBuildOptions::ShortText,
                        ISM::Default::Option::SettingsSetChrootBuildOptions::LongText,
                        ISM::Default::Option::SettingsSetChrootBuildOptions::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setChrootBuildOptions(ARGV[2+Ism.debugLevel])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootBuildOptions::SetText+ARGV[2+Ism.debugLevel])
                end
            end

        end
        
    end

end
