module ISM

    module Option

        class Software < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Software::ShortText,
                        ISM::Default::Option::Software::LongText,
                        ISM::Default::Option::Software::Description,
                        ISM::Default::Option::Software::Options)
            end

            def start
                if ARGV.size == 1
                    showHelp
                else
                    matchingOption = false
    
                    @options.each_with_index do |argument, index|
                        if ARGV[index] == argument.shortText || ARGV[index] == argument.longText
                            matchingOption = true
                            @options[index].start
                            break
                        end
                    end
    
                    if !matchingOption
                        #puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                        #puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                #"#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                #"#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
