module ISM

    class CommandLineOption

        module Default

            Padding = "  "

        end

        property shortText : String
        property longText : String
        property description : String
        property options : Array(ISM::CommandLineOption)

        def initialize(@shortText, @longText, @description, @options = Array(ISM::CommandLineOption).new)
        end

        def start
        end

        def showHelp
            puts @description

            shortTextArray = @options.map { |entry| entry.shortText}
            longTextArray = @options.map { |entry| entry.longText}

            highestShortTextSize = shortTextArray.max_by { |entry| entry.size }
            highestLongTextSize = longTextArray.max_by { |entry| entry.size }

            @options.each do |option|

                shortTextPadding = Default::Padding
                longTextPadding = Default::Padding

                limit = (highestShortTextSize.size - option.shortText.size)

                (1..limit).each do
                    shortTextPadding += " "
                end

                limit = (highestLongTextSize.size - option.longText.size)

                (1..limit).each do
                    longTextPadding += " "
                end

                puts    " #{option.shortText.colorize(:white)}#{shortTextPadding}" +
                        "#{option.longText.colorize(:white)}#{longTextPadding}" +
                        "#{option.description.colorize(:green)}"
            end

            rescue exception
                ISM::Error.show(className: self.class.name,
                                functionName: "showHelp",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
