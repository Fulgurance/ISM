module ISM

    module Option

        class SoftwareSearch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSearch::ShortText,
                        ISM::Default::Option::SoftwareSearch::LongText,
                        ISM::Default::Option::SoftwareSearch::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    matchingSoftwaresArray = Array(ISM::AvailableSoftware).new
    
                    Ism.softwares.each do |software|
                        if software.name.includes?(ARGV[2+Ism.debugLevel]) || software.name.downcase.includes?(ARGV[2+Ism.debugLevel])
                            matchingSoftwaresArray << software
                        end
                    end

                    if matchingSoftwaresArray.empty?
                        puts ISM::Default::Option::SoftwareSearch::NoMatchFound + "#{ARGV[2+Ism.debugLevel].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareSearch::NoMatchFoundAdvice
                    else
                        puts "\n"

                        matchingSoftwaresArray.each do |software|
                            puts    ISM::Default::Option::SoftwareSearch::NameField +
                                        "#{software.name.colorize(:green)}"

                            puts    ISM::Default::Option::SoftwareSearch::DescriptionField +
                                        "#{software.versions.last.description.colorize(:green)}"
                                
                            architecturesText = ""
                            software.versions.last.architectures.each_with_index do |architecture, index|
                                architecturesText += "#{architecture.colorize(:green)}"
                                if index+1 < software.versions.last.architectures.size
                                    architecturesText += " | "
                                end
                            end
                            if architecturesText.empty?
                                architecturesText = "None"
                            end
                            puts    ISM::Default::Option::SoftwareSearch::AvailablesArchitecturesField +
                                        "#{architecturesText.colorize(:green)}"
                                
                            puts    ISM::Default::Option::SoftwareSearch::WebsiteField +
                                        "#{software.versions.last.website.colorize(:green)}"
                                
                            versionsText = ""
                            software.versions.each_with_index do |version, index|
                                versionsText += "#{version.version.colorize(:green)}"
                                if index+1 < software.versions.size
                                        versionsText += " | "
                                end
                            end
                            puts    ISM::Default::Option::SoftwareSearch::AvailablesVersionsField +
                                        "#{versionsText}"

                            installedVersionText = ""
                            Ism.installedSoftwares.each_with_index do |installed, index|
                                if software.name == installed.name
                                    installedVersionText += "\n\t| #{installed.version.colorize(:green)}"

                                    installedVersionText += " { "

                                    installed.options.each do |option|

                                        if option.active
                                            installedVersionText += "#{option.name.colorize(:red)}"
                                        else
                                            installedVersionText += "#{option.name.colorize(:blue)}"
                                        end

                                        installedVersionText += " "
                                    end

                                    installedVersionText += "}"

                                end

                            end

                            if installedVersionText.empty?
                                installedVersionText = "None"
                            end

                            puts    ISM::Default::Option::SoftwareSearch::InstalledVersionField +
                                        "#{installedVersionText.colorize(:green)}"

                            puts    "#{ISM::Default::Option::SoftwareSearch::OptionsField}#{software.versions.last.options.empty? ? "None".colorize(:green) : ""}"

                            software.versions.last.options.each do |option|
                                puts "[#{option.active ? "*".colorize(:green) : " "}] #{option.name.colorize(:green)}: #{option.description}"
                            end

                            puts "\n"
                        end

                    end
    
                end
            end

        end
        
    end

end
