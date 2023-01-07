module ISM

    module Option

        class PortSetTargetVersion < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortSetTargetVersion::ShortText,
                        ISM::Default::Option::PortSetTargetVersion::LongText,
                        ISM::Default::Option::PortSetTargetVersion::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.portsSettings.setTargetVersion(ARGV[2+Ism.debugLevel])
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::PortSetTargetVersion::SetText +
                            ARGV[2+Ism.debugLevel]
                end
            end

        end
        
    end

end
