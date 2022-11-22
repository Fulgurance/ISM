module ISM

    module Option

        class SettingsSetBuildOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetBuildOptions::ShortText,
                        ISM::Default::Option::SettingsSetBuildOptions::LongText,
                        ISM::Default::Option::SettingsSetBuildOptions::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setBuildOptions(ARGV[2+Ism.debugLevel])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetBuildOptions::SetText +
                            ARGV[2+Ism.debugLevel]
                end
            end

        end
        
    end

end
