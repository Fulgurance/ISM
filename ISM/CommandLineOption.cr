module ISM

    class CommandLineOption

        property shortText = ISM::Default::CommandLineOption::ShortText
        property longText = ISM::Default::CommandLineOption::LongText
        property description = ISM::Default::CommandLineOption::Description
        property options = ISM::Default::CommandLineOption::Options

        def initialize( shortText = ISM::Default::CommandLineOption::ShortText,
                        longText = ISM::Default::CommandLineOption::LongText,
                        description = ISM::Default::CommandLineOption::Description,
                        options = ISM::Default::CommandLineOption::Options)
            @shortText = shortText
            @longText = longText
            @description = description
            @options = options
        end

        def start
        end

        def showHelp
            puts @description
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end
        end

    end

end
