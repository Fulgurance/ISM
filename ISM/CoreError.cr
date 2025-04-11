module ISM

    module Core

        module Error

            def self.show(  className : String,
                            functionName : String,
                            errorTitle : String,
                            error : String,
                            exception = Exception.new,
                            information = String.new,
                            errorCode = 1)
                limit = ISM::Default::Error::Title.size

                separatorText = String.new

                (0..limit).each do |index|
                    separatorText += "="
                end

                fullLog = (exception.backtrace.empty? ? exception.backtrace.join("\n") : exception.message)

                title = "#{ISM::Default::Error::Title.colorize(:red)}"
                separatorText = "#{separatorText.colorize(:red)}"
                errorText = "\n#{fullLog.colorize(Colorize::ColorRGB.new(255,100,100))}"
                help = "\n#{ISM::Default::Error::Help.colorize(:red)}"

                puts "\n"
                puts separatorText
                puts title
                puts separatorText
                puts className
                puts functionName
                puts errorTitle
                puts error
                puts errorText
                puts code
                puts help
                puts "\n"

                ISM::Core.exitProgram(code: errorCode)

            end

        end

    end

end
