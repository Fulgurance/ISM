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
                    wrongMatch = false
                    badEntry = ""
                    matchingSoftwaresArray = Array(ISM::SoftwareInformation).new

                    Ism.softwares.each_with_index do |software, index|
                        if ARGV[2] == software.name || ARGV[2] == software.name.downcase
                            matchingSoftwaresArray << software.versions.last
                        else
                            software.versions.each do |version|
                                if ARGV[2] == version.versionName || ARGV[2] == version.versionName.downcase
                                    matchingSoftwaresArray << version
                                else
                                    wrongMatch = true
                                    badEntry = ARGV[2]
                                    break
                                end
                            end
                        end
                        if wrongMatch
                            break
                        end
                    end

                    #Add method to check dependencies, needed options ...
                    if wrongMatch
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{badEntry.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                    else
                        matchingSoftwaresArray.each do |software|
                            text = software.name + "-" + software.version
                            puts "\t" + "#{text.colorize(:green)}"
                        end

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
                                #software.install
                                file = File.open("ISM.task", "w")
                                #File.write( software.name+".task",
                                            #"require \"#{ISM::Default::Path::SoftwaresDirectory + "/" + software.name + "/" + "2.37" + "/" + "2.37"}\"\t")
                                #File.write( software.name+".task",
                                            #"target = Target.new\t")
                                #file.close
                                file << "require \"./#{ISM::Default::Path::SoftwaresDirectory + software.name + "/" + "2.37" + "/" + "2.37" + ".cr"}\"\n"
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
