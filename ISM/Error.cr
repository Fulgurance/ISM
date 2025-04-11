module ISM

    module Error

        def self.show(error : Exception)
            limit = ISM::Default::Error::Title.size

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "="
            end

            fullLog = (error.backtrace.empty? ? error.backtrace.join("\n") : error.message)

            title = "#{ISM::Default::Error::Title.colorize(:red)}"
            separatorText = "#{separatorText.colorize(:red)}"
            errorText = "\n#{fullLog.colorize(Colorize::ColorRGB.new(255,100,100))}"
            help = "\n#{ISM::Default::Error::Help.colorize(:red)}"

            puts "\n"
            puts separatorText
            puts title
            puts separatorText
            puts errorText
            puts help
            puts

            #TO DO: Show that the raising error process encounter an error itself and raise it too
            rescue error

        end

    end

end
