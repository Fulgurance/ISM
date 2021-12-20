module ISM

    module Option

        class SoftwareInstall < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareInstall::ShortText,
                        ISM::Default::Option::SoftwareInstall::LongText,
                        ISM::Default::Option::SoftwareInstall::Description,
                        ISM::Default::Option::SoftwareInstall::Options)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    matchingSoftwaresArray = Array(ISM::SoftwareInformation).new

                    #Remove duplicate softwares (example: I have two similars arguments)
                    ARGV[2..-1].each do |argument|
                        Ism.softwares.each do |software|
                            if argument == software.name || argument == software.name.downcase
                                matchingSoftwaresArray << software.versions.last
                            else
                                software.versions.each do |version|
                                    if argument == version.versionName || argument == version.versionName.downcase
                                        matchingSoftwaresArray << version
                                    end
                                end
                            end
                        end
                    end

                    #Add method to check dependencies, needed options ...
                    if ARGV.size-2 == matchingSoftwaresArray
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                    else
                        puts "\n"

                        matchingSoftwaresArray.each do |software|
                            softwareText = "#{software.name.colorize(:green)}" + "-" + software.version
                            optionsText = "{ "
                            software.options.each do |option|
                                if option.active
                                    optionsText += "#{option.name.colorize(:red)}"
                                else
                                    optionsText += "#{option.name.colorize(:blue)}"
                                end
                                optionsText += " "
                            end
                            optionsText += "}"
                            puts "\t" + softwareText + " " + optionsText + "\n"
                        end

                        puts "\n"

                        userInput = ""
                        userAgreement = false

                        puts ISM::Default::Option::SoftwareInstall::InstallQuestion + 
                                "[" + "#{ISM::Default::Option::SoftwareInstall::YesReplyOption.colorize(:green)}" + 
                                "/" + "#{ISM::Default::Option::SoftwareInstall::NoReplyOption.colorize(:red)}" + "]"

                        loop do
                            userInput = gets
                        
                            if userInput == ISM::Default::Option::SoftwareInstall::YesReplyOption
                                userAgreement = true
                                break
                            end
                            if userInput == ISM::Default::Option::SoftwareInstall::NoReplyOption
                                break
                            end
                        end

                        if userAgreement
                            matchingSoftwaresArray.each_with_index do |software, index|
                                file = File.open("ISM.task", "w")
                                file << "require \"./#{ISM::Default::Path::SoftwaresDirectory + software.name + "/" + software.version + "/" + software.version + ".cr"}\"\n"
                                file << "target = Target.new\n"
                                file << "target.download"
                                file.close
                                Ism.notifyOfDownload(software)
                                puts `crystal ISM.task`
                            end
                        end

                    end
    
                end
            end

        end
        
    end

end
