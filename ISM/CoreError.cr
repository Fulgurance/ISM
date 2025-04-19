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

                fullLog = (exception.backtrace.empty? ? exception.backtrace.join("\n") : exception.message)

                title = "#{ISM::Default::Error::Title.colorize(:red)}"

                errorText = "#{fullLog.colorize(Colorize::ColorRGB.new(255,100,100))}"
                help = "#{ISM::Default::Error::Help.colorize(:red)}"

                errorReport = <<-REPORT
                [ #{title} ]

                Class: #{className.colorize(:red)}
                Function: #{functionName.colorize(:red)}

                #{errorTitle}
                #{error.colorize(:red)}

                Exception:
                #{errorText}

                Exit code: #{errorCode.colorize(:red)}

                #{help.colorize(:red)}
                REPORT

                puts "\n#{errorReport}\n"

                ISM::Core.exitProgram(code: errorCode)

            end

        end

    end

end
