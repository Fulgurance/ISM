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
                    matching = false
                    wrongArgument = ""

                    #Remove duplicate softwares (example: I have two similars arguments)
                    ARGV[2..-1].each do |argument|
                        matching = false

                        Ism.softwares.each do |software|

                            if argument == software.name || argument == software.name.downcase
                                matchingSoftwaresArray << software.versions.last
                                matching = true
                            else
                                software.versions.each do |version|
                                    if argument == version.versionName || argument == version.versionName.downcase
                                        matchingSoftwaresArray << version
                                        matching = true
                                    end
                                end
                            end

                        end
                        if !matching
                            wrongArgument = argument
                            break
                        end
                        
                    end

                    #Add method to check dependencies, needed options ...
                    if !matching
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{wrongArgument.colorize(:green)}"#"#{ARGV[2].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                    else
                        puts "\n"

                        matchingSoftwaresArray.each do |software|
                            softwareText = "#{software.name.colorize(:green)}" + " /" + "#{software.version.colorize(:cyan)}" + "/ "
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

                        puts "#{ISM::Default::Option::SoftwareInstall::InstallQuestion.colorize.mode(:underline)}" + 
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
                                file << "target.download\n"
                                file << "target.check\n"
                                file << "target.extract\n"
                                file << "target.patch\n"
                                file << "target.prepare\n"
                                file << "target.configure\n"
                                file << "target.build\n"
                                file << "target.install\n"
                                file.close
                                Process.run("crystal",args: ["ISM.task"],output: :inherit)
                            end
                        end

                    end
    
                end
            end

        end
        
    end

end
