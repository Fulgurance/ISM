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
                    path = ARGV[2+Ism.debugLevel]

                    if path[-1] != "/"
                        path = path+"/"
                    end

                    Ism.settings.setRootPath(path)
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetRootPath::SetText +
                            path
                end
            end

        end
        
    end

end
