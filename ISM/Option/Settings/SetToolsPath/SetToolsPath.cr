module ISM

    module Option

        class SettingsSetToolsPath < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetToolsPath::ShortText,
                        ISM::Default::Option::SettingsSetToolsPath::LongText,
                        ISM::Default::Option::SettingsSetToolsPath::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setToolsPath(ARGV[2])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetToolsPath::SetText +
                            ARGV[2]
                end
            end

        end
        
    end

end
