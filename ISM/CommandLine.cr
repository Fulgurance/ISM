module ISM

    class CommandLine

        property options = ISM::Default::CommandLine::Options

        def initialize(options = ISM::Default::CommandLine::Options)
            @options = options
        end

        def start
            if ARGV.empty? || ARGV[0] == ISM::Default::Option::Help::ShortText || ARGV[0] == ISM::Default::Option::Help::LongText
                showHelp
            else
                matchingOption = false
                matchingOptionIndex = 0

                @options.each_with_index do |argument, index|
                    if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                        matchingOption = true
                        matchingOptionIndex = index
                    end
                end

                if matchingOption
                    @options[matchingOptionIndex].start
                else
                    puts "#{ISM::Default::Message::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                    puts    "#{ISM::Default::Message::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                            "#{ISM::Default::Message::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                            "#{ISM::Default::Message::ErrorUnknowArgumentHelp3.colorize(:white)}"
                end
            end
        end

        def showHelp
            puts ISM::Default::Message::Title
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end
        end

    end

end
