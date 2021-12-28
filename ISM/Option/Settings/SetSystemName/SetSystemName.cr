module ISM

    module Option

        class SettingsSetSystemName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemName::ShortText,
                        ISM::Default::Option::SettingsSetSystemName::LongText,
                        ISM::Default::Option::SettingsSetSystemName::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemName(ARGV[2])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetSystemName::SetText +
                            ARGV[2]
                end
            end

        end
        
    end

end
