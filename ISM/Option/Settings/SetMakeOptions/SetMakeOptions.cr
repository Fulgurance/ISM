module ISM

    module Option

        class SettingsSetMakeOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetMakeOptions::ShortText,
                        ISM::Default::Option::SettingsSetMakeOptions::LongText,
                        ISM::Default::Option::SettingsSetMakeOptions::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setMakeOptions(ARGV[2+Ism.debugLevel])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetMakeOptions::SetText +
                            ARGV[2+Ism.debugLevel]
                end
            end

        end
        
    end

end
