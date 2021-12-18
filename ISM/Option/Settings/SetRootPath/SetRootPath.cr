module ISM

    module Option

        class SettingsSetRootPath < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetRootPath::ShortText,
                        ISM::Default::Option::SettingsSetRootPath::LongText,
                        ISM::Default::Option::SettingsSetRootPath::Description,
                        ISM::Default::Option::SettingsSetRootPath::Options)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setRootPath(ARGV[2])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetRootPath::SetText +
                            ARGV[2]
                end
            end

        end
        
    end

end
