module ISM

    module Error

        def self.show(  className : String,
                        functionName : String,
                        errorTitle : String,
                        error : String,
                        exception = Exception.new,
                        information = String.new,
                        errorCode = 1)

            fullLog = (exception.backtrace.empty? ? exception.backtrace.join("\n") : exception.message)

            title = (className == "Software" ? ISM::Default::Error::InstallerTitle.colorize(:red) : ISM::Default::Error::Title.colorize(:red))

            errorText = "#{fullLog.colorize(:red)}"
            help = "#{ISM::Default::Error::Help.colorize(:red)}"

            errorReport = <<-REPORT
            [ #{title} ]

            Class: #{className.colorize(:red)}
            Function: #{functionName.colorize(:red)}

            #{errorTitle.colorize(:red)}
            #{error}

            Exception:
            #{errorText}

            Exit code: #{errorCode.colorize(:red)}

            #{help.colorize(:red)}
            REPORT

            puts "\n#{errorReport}\n"

            Ism.exitProgram(code: errorCode)

        end

    end

end
