module ISM

    module Error

        module Default

            Title = "Internal error"
            InstallerTitle = "Installer failure"
            Help = "#{CommandLine::Default::Name.upcase} raised that error because the ran script did not call properly a system command or the system command itself need to be fix."
            SystemCommandFailure = "The following system command failed to run: "

        end

        def self.show(  className : String,
                        functionName : String,
                        errorTitle : String,
                        error : String,
                        exception = Exception.new,
                        information = String.new,
                        errorCode = 1)

            fullLog = (exception.backtrace.empty? ? exception.backtrace.join("\n") : exception.message)

            title = (className == "Software" ? Default::InstallerTitle.colorize(:red) : Default::Title.colorize(:red))

            errorText = "#{fullLog.colorize(:red)}"
            help = "#{Default::Help.colorize(:red)}"

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
