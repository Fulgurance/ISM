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
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
