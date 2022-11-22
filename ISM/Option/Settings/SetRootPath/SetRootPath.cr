module ISM

    module Option

        class SettingsSetRootPath < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetRootPath::ShortText,
                        ISM::Default::Option::SettingsSetRootPath::LongText,
                        ISM::Default::Option::SettingsSetRootPath::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setRootPath(ARGV[2+Ism.debugLevel])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetRootPath::SetText +
                            ARGV[2+Ism.debugLevel]
                end
            end

        end
        
    end

end
