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
                puts "Class: #{className.colorize(:red)}"
                puts "Function: #{functionName.colorize(:red)}"
                puts "#{errorTitle.colorize(:red)}"
                puts "#{error.colorize(:red)}"
                puts "Raised error:#{errorText}"
                puts "Exit code: #{errorCode.colorize(:red)}"
                puts "#{help.colorize(:red)}"
                puts "\n"

                ISM::Core.exitProgram(code: errorCode)

            end

        end

    end

end
