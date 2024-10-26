module ISM

    module Option

        class PortSearch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortSearch::ShortText,
                        ISM::Default::Option::PortSearch::LongText,
                        ISM::Default::Option::PortSearch::Description)
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
                        puts ISM::Default::Option::PortSearch::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                        puts ISM::Default::Option::PortSearch::NoMatchFoundAdvice
                    else
                        matchingPortArray.each_with_index do |port, index|

                            nameField = "#{ISM::Default::Option::PortSearch::NameText.colorize(:green)} #{port.name.colorize(Colorize::ColorRGB.new(255,100,100))}"
                            urlField = "#{ISM::Default::Option::PortSearch::UrlText.colorize(:green)} #{port.url}"
                            availableSoftwareField = "#{ISM::Default::Option::PortSearch::AvailableSoftwareText.colorize(:green)} #{port.softwareNumber}"

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
