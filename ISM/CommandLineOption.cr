module ISM

    class CommandLineOption

        property shortText : String
        property longText : String
        property description : String
        property options : Array(ISM::CommandLineOption)

        def initialize(@shortText, @longText, @description, @options = Array(ISM::CommandLineOption).new)
        end

        def start

            rescue error
            ISM::Core::Error.show(  className: "CommandLineOption",
                                    functionName: "start",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

        def showHelp
            puts @description
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end

            rescue error
            ISM::Core::Error.show(  className: "CommandLineOption",
                                    functionName: "showHelp",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
        end

    end

end
