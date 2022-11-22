module ISM

    module Option

        class SettingsSetSourcesPath < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSourcesPath::ShortText,
                        ISM::Default::Option::SettingsSetSourcesPath::LongText,
                        ISM::Default::Option::SettingsSetSourcesPath::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setSourcesPath(ARGV[2+Ism.debugLevel])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetSourcesPath::SetText +
                            ARGV[2+Ism.debugLevel]
                end
            end

        end
        
    end

end
