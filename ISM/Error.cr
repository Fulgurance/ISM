module ISM

    module Error

        def self.show(error : Exception)
            limit = ISM::Default::Error::InternalErrorTitle.size

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "="
            end

            fullLog = (error.backtrace.empty? ? error.backtrace.join("\n") : error.message)

            title = "#{ISM::Default::CommandLine::InternalErrorTitle.colorize(:red)}"
            separatorText = "#{separatorText.colorize(:red)}"
            errorText = "\n#{fullLog.colorize(Colorize::ColorRGB.new(255,100,100))}"
            help = "\n#{ISM::Default::CommandLine::SystemCallErrorNotificationHelp.colorize(:red)}"

            puts
            puts separatorText
            puts title
            puts separatorText
            puts errorText
            puts help

            rescue error
                printSystemCallErrorNotification(error)
                exitProgram
        end

    end

end
