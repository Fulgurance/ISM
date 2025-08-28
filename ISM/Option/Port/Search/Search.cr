module ISM

    module Option

        class PortSearch < ISM::CommandLineOption

            module Default

                ShortText = "-s"
                LongText = "search"
                Description = "Search a specified port in the database"
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                NameText = "Name:"
                UrlText = "Url:"
                AvailableSoftwareText = "Available softwares:"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    matchingPortArray = Array(ISM::Port).new

                    Ism.ports.each do |port|
                        if port.name.includes?(ARGV[2]) || port.name.downcase.includes?(ARGV[2])
                            matchingPortArray << port
                        end
                    end

                    if matchingPortArray.empty?
                        puts Default::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                        puts Default::NoMatchFoundAdvice
                    else
                        matchingPortArray.each_with_index do |port, index|

                            nameField = "#{Default::NameText.colorize(:green)} #{port.name.colorize(Colorize::ColorRGB.new(255,100,100))}"
                            urlField = "#{Default::UrlText.colorize(:green)} #{port.url}"
                            availableSoftwareField = "#{Default::AvailableSoftwareText.colorize(:green)} #{port.softwareNumber}"

                            puts nameField
                            puts urlField
                            puts availableSoftwareField

                            if index < matchingPortArray.size-1
                                Ism.showSeparator
                            end

                        end
                    end

                end
            end

        end

    end

end
