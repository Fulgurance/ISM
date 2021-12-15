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
                                software.install
                            end
                        end
                    else
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFound
                    end
    
                end
            end

        end
        
    end

end
