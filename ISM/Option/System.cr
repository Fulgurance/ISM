module ISM

    module Option

        class System < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::System::ShortText,
                        ISM::Default::Option::System::LongText,
                        ISM::Default::Option::System::Description,
                        ISM::Default::Option::System::Options)
            end

            def start
                #if ARGV.empty? || ARGV[1] == ISM::Default::Option::Software::ShortText || ARGV[1] == ISM::Default::Option::Software::LongText
                #if ARGV[1] == ISM::Default::Option::Software::ShortText
                if ARGV.size == 1
                    showHelp
                #else
                    #matchingOption = false
                    #matchingOptionIndex = 0
    
                    #@options.each_with_index do |argument, index|
                        #if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                            #matchingOption = true
                            #matchingOptionIndex = index
                        #end
                    #end
    
                    #if matchingOption
                        #@options[matchingOptionIndex].start
                    #else
                        #puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                        #puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                #"#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                #"#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    #end
                end
            end

        end
        
    end

end
