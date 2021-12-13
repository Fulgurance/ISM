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
                    matchingSoftware = false
                    matchingSoftwaresArray = Array(ISM::Software).new

                    Ism.softwares.each_with_index do |software, index|
                        if ARGV[2].downcase == software.information.name
                            matchingSoftware = true
                            matchingSoftwaresArray << software
                        end
                    end

                    if matchingSoftware
                        userInput = ""
                        userAgreement = false
                        
                        puts "Would you like to install this software ? [y/n]"

                        puts ISM::Default::Option::SoftwareInstall::InstallQuestion + 
                                "[" + "#{ISM::Default::Option::SoftwareInstall::YesReplyOption.colorize(:green)}" + 
                                "/" + "#{ISM::Default::Option::SoftwareInstall::NoReplyOption.colorize(:red)}" + "]"

                        loop do
                            userAgreement = gets
                        
                            if userInput == ISM::Default::Option::SoftwareInstall::YesReplyOption || userInput == ISM::Default::Option::SoftwareInstall::NoReplyOption
                                if userInput == "y"
                                    userAgreement = true
                                end
                                break
                            end
                        end

                        #if userAgreement
                            #matchingSoftwaresArray.each_with_index do |software, index|
                                #software.install
                            #end
                        #end
                    end
    
                    #if !matchingSoftware
                        #puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                        #puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                #"#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                #"#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    #end
                end
            end

        end
        
    end

end
