module ISM

    class CommandLineOption

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

                shortTextPadding = String.new

                if option.shortText.size < 8
                    shortTextPadding += "\t"
                end

                limit = (highestShortTextSize.size/8 - option.shortText.size/8)

                (0..(limit)).each do |i|
                    shortTextPadding += "\t"
                end

                ############################

                longTextPadding = String.new

                if option.longText.size < 8
                    longTextPadding += "\t"
                end

                limit = (highestLongTextSize.size/8 - option.longText.size/8)

                (0..(limit)).each do |i|
                    longTextPadding += "\t"
                end

                #############################

                puts    "\t#{option.shortText.colorize(:white)}#{shortTextPadding}" +
                        "#{option.longText.colorize(:white)}#{longTextPadding}" +
                        "#{option.description.colorize(:green)}"
            end

            # @options.each do |argument|
            #     puts    "\t" + "#{argument.shortText.colorize(:white)}" +
            #             "\t" + "#{argument.longText.colorize(:white)}" +
            #             "\t" + "#{argument.description.colorize(:green)}"
            # end

            rescue exception
                ISM::Error.show(className: "CommandLineOption",
                                functionName: "showHelp",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
