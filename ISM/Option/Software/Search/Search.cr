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
                if ARGV.size == 2
                    showHelp
                else
                    if ARGV.size == 2
                        showHelp
                    else
                        matchingSoftwaresArray = Array(ISM::AvailableSoftware).new
    
                        Ism.softwares.each do |software|
                            if software.name.includes?(ARGV[2]) || software.name.downcase.includes?(ARGV[2])
                                matchingSoftwaresArray << software
                            end
                        end

                        if matchingSoftwaresArray.empty?
                            puts ISM::Default::Option::SoftwareSearch::NoMatchFound + "#{ARGV[2].colorize(:green)}"
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
                                        if index+1 < Ism.installedSoftwares.size && installedVersionText != ""
                                            installedVersionText += " | "
                                        end
                                        installedVersionText += "#{installed.version.colorize(:green)}"
                                    end

                                end
                                if installedVersionText.empty?
                                    installedVersionText = "None"
                                end
                                puts    ISM::Default::Option::SoftwareSearch::InstalledVersionField +
                                        "#{installedVersionText.colorize(:green)}"

                                optionsText = ""
                                software.versions.last.options.each_with_index do |option, index|
                                    if option.active
                                        optionsText += "#{option.name.colorize(:red)}"
                                    else
                                        optionsText += "#{option.name.colorize(:blue)}"
                                    end
                                    if index+1 < software.versions.last.options.size
                                        optionsText += " | "
                                    end
                                end
                                if optionsText.empty?
                                    optionsText = "None"
                                end
                                puts    ISM::Default::Option::SoftwareSearch::OptionsField +
                                        "#{optionsText.colorize(:green)}"

                                puts "\n"
                            end
                        end

                    end
    
                end
            end

        end
        
    end

end
