module ISM

    module Option

        class PortClose < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortClose::ShortText,
                        ISM::Default::Option::PortClose::LongText,
                        ISM::Default::Option::PortClose::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    if ISM::Port.exists(ARGV[2+Ism.debugLevel])
                        puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::PortClose::CloseText +
                            ARGV[2+Ism.debugLevel]
                            
                        ISM::Port.delete(ARGV[2+Ism.debugLevel])
                    else
                        puts    ISM::Default::Option::PortClose::NoMatchFoundText1 +
                                ARGV[2+Ism.debugLevel] +
                                ISM::Default::Option::PortClose::NoMatchFoundText2
                    end
                end
            end

        end
        
    end

end
