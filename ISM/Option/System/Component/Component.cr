module ISM

    module Option

        class System

            class Component < ISM::CommandLineOption

                module Default

                    ShortText = "-c"
                    LongText = "component"
                    Description = "Manage and configure system component"
                    Options = [ Option::System::Component::List.new,
                                Option::System::Component::Setup.new,
                                Option::System::Component::SetupAll.new,
                                Option::System::Component::Activate.new,
                                Option::System::Component::Desactivate.new]

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description,
                            Default::Options)
                end

                def start
                    if ARGV.size == 2
                        showHelp
                    else
                        matchingOption = false

                        @options.each_with_index do |argument, index|
                            if ARGV[2] == argument.shortText || ARGV[2] == argument.longText
                                matchingOption = true
                                @options[index].start
                                break
                            end
                        end

                        if  !matchingOption && ARGV.size > 3 && ARGV[3] == Option::System::Component::Activate::Default::ShortText ||
                            !matchingOption && ARGV.size > 3 && ARGV[3] == Option::System::Component::Activate::Default::LongText
                            matchingOption = true
                            @options[-1].start
                        end

                        if  !matchingOption && ARGV.size > 3 && ARGV[3] == Option::System::Component::Desactivate::Default::ShortText ||
                            !matchingOption && ARGV.size > 3 && ARGV[3] == Option::System::Component::Desactivate::Default::LongText
                            matchingOption = true
                            @options[-2].start
                        end

                        if !matchingOption
                            puts "#{CommandLine::Default::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[1].colorize(:white)}"
                            puts    "#{CommandLine::Default::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                    "#{CommandLine::Default::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                    "#{CommandLine::Default::ErrorUnknowArgumentHelp3.colorize(:white)}"
                        end
                    end
                end

            end

        end
        
    end

end
