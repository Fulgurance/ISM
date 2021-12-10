module ISM

    module Option

        class SoftwareSynchronize < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSynchronize::ShortText,
                        ISM::Default::Option::SoftwareSynchronize::LongText,
                        ISM::Default::Option::SoftwareSynchronize::Description,
                        ISM::Default::Option::SoftwareSynchronize::Options)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    #matchingOption = false
                    matchingSoftware = false
                    matchingSoftwaresArray = Array(ISM::SoftwareInformation).new

                    #@options.each_with_index do |argument, index|
                        #if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                            #matchingOption = true
                            #@options[index].start
                            #break
                        #end
                    #end

                    Ism.softwares.each_with_index do |software, index|
                        if ARGV[2].downcase == software.name
                            matchingOption = true
                            matchingSoftwaresArray << software
                        end
                    end

                    puts matchingSoftwaresArray
    
                    #if !matchingOption
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
