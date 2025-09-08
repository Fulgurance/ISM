module ISM

    module Option

        class Help < CommandLine::Option

            module Default

                ShortText = "-h"
                LongText = "help"
                Description = "Display the help how to use ISM"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                puts CommandLine::Default::Title

                shortTextArray = Ism.options.map { |entry| entry.shortText}
                longTextArray = Ism.options.map { |entry| entry.longText}

                highestShortTextSize = shortTextArray.max_by { |entry| entry.size }
                highestLongTextSize = longTextArray.max_by { |entry| entry.size }

                Ism.options.each do |option|

                    shortTextPadding = CommandLine::Option::Default::Padding
                    longTextPadding = CommandLine::Option::Default::Padding

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
            end

        end
        
    end

end
