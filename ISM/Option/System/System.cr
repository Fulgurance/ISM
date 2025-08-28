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
                        puts "#{CommandLine::Default::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                        puts    "#{CommandLine::Default::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{CommandLine::Default::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{CommandLine::Default::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end

    end

end
