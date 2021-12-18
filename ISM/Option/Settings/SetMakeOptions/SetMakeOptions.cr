module ISM

    module Option

        class SettingsSetMakeOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetMakeOptions::ShortText,
                        ISM::Default::Option::SettingsSetMakeOptions::LongText,
                        ISM::Default::Option::SettingsSetMakeOptions::Description,
                        ISM::Default::Option::SettingsSetMakeOptions::Options)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setMakeOptions(ARGV[2])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetMakeOptions::SetText +
                            ARGV[2]
                end
            end

        end
        
    end

end
