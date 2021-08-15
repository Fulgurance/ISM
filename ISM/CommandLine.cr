module ISM

    class CommandLine

        property options = ISM::Default::CommandLine::Options
        property settings = ISM::Default::CommandLine::Settings

        def initialize( options = ISM::Default::CommandLine::Options,
                        settings = ISM::Default::CommandLine::Settings)
            @options = options
            @settings = settings
        end

        def start
            checkSoftwareDatabase
            checkEnteredArguments
        end

        def checkSoftwareDatabase
            if !Dir.exists?(ISM::Default::Path::SoftwareDatabase)
                Dir.mkdir(ISM::Default::Path::SoftwareDatabase)
            end
        end

        def checkEnteredArguments
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
                    showErrorUnknowArgument
                end
            end
        end

        def showHelp
            puts ISM::Default::CommandLine::Title
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end
        end

        def showErrorUnknowArgument
            puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
            puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
        end

    end

end
