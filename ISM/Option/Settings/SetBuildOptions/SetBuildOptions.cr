module ISM

    module Option

        class SettingsSetBuildOptions < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetBuildOptions::ShortText,
                        ISM::Default::Option::SettingsSetBuildOptions::LongText,
                        ISM::Default::Option::SettingsSetBuildOptions::Description,
                        ISM::Default::Option::SettingsSetBuildOptions::Options)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setBuildOptions(ARGV[2])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetBuildOptions::SetText +
                            ARGV[2]
                end
            end

        end
        
    end

end
