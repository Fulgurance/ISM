module ISM

    module Option

        class SoftwareUpdate < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareUpdate::ShortText,
                        ISM::Default::Option::SoftwareUpdate::LongText,
                        ISM::Default::Option::SoftwareUpdate::Description,
                        ISM::Default::Option::SoftwareUpdate::Options)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    #matchingOption = false
                    #matchingSoftware = false
                    #matchingSoftwaresArray = Array(ISM::Software).new

                    #@options.each_with_index do |argument, index|
                        #if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                            #matchingOption = true
                            #@options[index].start
                            #break
                        #end
                    #end

                    #Ism.softwares.each_with_index do |software, index|
                        #if ARGV[2].downcase == software.information.name
                            #matchingOption = true
                            #matchingSoftwaresArray << software
                        #end
                    #end
    
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
