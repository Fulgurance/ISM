module ISM

    module Option

        class Alternative < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Alternative::ShortText,
                        ISM::Default::Option::Alternative::LongText,
                        ISM::Default::Option::Alternative::Description,
                        ISM::Default::Option::Alternative::Options)
            end

            def start
                if ARGV.size == 1+Ism.debugLevel
                    showHelp
                else
                    matchingOption = false
    
                    @options.each_with_index do |argument, index|
                        if ARGV[1+Ism.debugLevel] == argument.shortText || ARGV[1+Ism.debugLevel] == argument.longText
                            matchingOption = true
                            @options[index].start
                            break
                        end
                    end
    
                    if !matchingOption
                        puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0+Ism.debugLevel].colorize(:white)}"
                        puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
