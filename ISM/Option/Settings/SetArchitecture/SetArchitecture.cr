module ISM

    module Option

        class SettingsSetArchitecture < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetArchitecture::ShortText,
                        ISM::Default::Option::SettingsSetArchitecture::LongText,
                        ISM::Default::Option::SettingsSetArchitecture::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setArchitecture(ARGV[2])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsSetArchitecture::SetText +
                            ARGV[2]
                end
            end

        end
        
    end

end
