module ISM

    module Option

        class SystemComponent < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SystemComponent::ShortText,
                        ISM::Default::Option::SystemComponent::LongText,
                        ISM::Default::Option::SystemComponent::Description,
                        ISM::Default::Option::SystemComponent::Options)
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

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::ComponentActivate::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::ComponentActivate::LongText
                        matchingOption = true
                        @options[-4].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::ComponentDesactivate::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::ComponentDesactivate::LongText
                        matchingOption = true
                        @options[-3].start
                    end

                    if !matchingOption
                        puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[1].colorize(:white)}"
                        puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
