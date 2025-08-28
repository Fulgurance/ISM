module ISM

    module Option

        class Help < ISM::CommandLineOption

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
                Ism.options.each do |argument|
                    puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                            "\t" + "#{argument.longText.colorize(:white)}" +
                            "\t" + "#{argument.description.colorize(:green)}"
                end
            end

        end
        
    end

end
