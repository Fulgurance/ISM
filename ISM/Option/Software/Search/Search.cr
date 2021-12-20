module ISM

    module Option

        class SoftwareSearch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSearch::ShortText,
                        ISM::Default::Option::SoftwareSearch::LongText,
                        ISM::Default::Option::SoftwareSearch::Description,
                        ISM::Default::Option::SoftwareSearch::Options)
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
                            puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                            puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                        else
                            puts "\n"

                            matchingSoftwaresArray.each do |software|
                                puts "Name: " + "#{software.name.colorize(:green)}"
                                puts "Description: " + "#{software.versions.last.description.colorize(:green)}"
                                puts "Architectures: " + "#{software.versions.last.description.colorize(:green)}"
                                puts "Website: " + "#{software.versions.last.website.colorize(:green)}"
                                
                                versionsText = ""
                                software.versions.each_with_index do |version, index|
                                    versionsText += "#{version.version.colorize(:green)}"
                                    if index+1 < software.versions.size
                                        versionsText += " | "
                                    end
                                end
                                puts "Available(s) Version(s): " + "#{versionsText}"

                                installedVersionText = "" 
                                Ism.installedSoftwares.each do |installed|
                                    if software.name == installed.name
                                        installedVersionText += "#{installed.name.colorize(:green)}"
                                    end
                                end
                                if installedVersionText.empty?
                                    installedVersionText = "None"
                                end
                                puts "Installed Version: " + "#{installedVersionText.colorize(:green)}"

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
                                puts "Options: " + "#{optionsText}"

                                puts "\n"
                            end
                        end

                    end
    
                end
            end

        end
        
    end

end
