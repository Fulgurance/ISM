module ISM

    module Option

        class Port < CommandLine::Option

            module Default

                ShortText = "-p"
                LongText = "port"
                Description = "Manage #{CommandLine::Default::Name.upcase} ports"
                Options = [ Option::Port::Open.new,
                            Option::Port::Close.new,
                            Option::Port::Synchronize.new,
                            Option::Port::Search.new]

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description,
                        Default::Options)
            end

            def start
                if ARGV.size == 1
                    showHelp
                else
                    matchingOption = false
    
                    @options.each_with_index do |argument, index|
                        if ARGV[1] == argument.shortText || ARGV[1] == argument.longText
                            matchingOption = true
                            @options[index].start
                            break
                        end
                    end
    
                    if !matchingOption
                        puts "#{ISM::Core::Notification::Default::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                        puts    "#{ISM::Core::Notification::Default::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{ISM::Core::Notification::Default::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{ISM::Core::Notification::Default::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
