module ISM

    module Option

        class SettingsSetChrootMakeOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootMakeOptions::ShortText,
                        ISM::Default::Option::SettingsSetChrootMakeOptions::LongText,
                        ISM::Default::Option::SettingsSetChrootMakeOptions::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setChrootMakeOptions(ARGV[2+Ism.debugLevel])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetChrootMakeOptions::SetText +
                            ARGV[2+Ism.debugLevel]
                end
            end

        end
        
    end

end
