module ISM

    module Option

        class SoftwareInstall < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareInstall::ShortText,
                        ISM::Default::Option::SoftwareInstall::LongText,
                        ISM::Default::Option::SoftwareInstall::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    matchingSoftwaresArray = Array(ISM::SoftwareInformation).new
                    matching = false
                    wrongArgument = ""

                    #####################
                    #Get wanted softwares
                    #####################
                    ARGV[2..-1].uniq.each do |argument|
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

                    ################################
                    #Get dependencies array by level
                    ################################
                    currentDependenciesArray = Array(ISM::SoftwareDependency).new

                    matchingSoftwaresArray.each do |software|
                        currentDependency = ISM::SoftwareDependency.new
                        currentDependency.name = software.name
                        currentDependency.version = software.version
                        currentDependency.options = software.options
                        currentDependenciesArray << currentDependency
                    end

                    nextDependenciesArray = currentDependenciesArray
                    dependenciesLevelArray = currentDependenciesArray

                    dependencies = Array(ISM::SoftwareDependency).new
                    neededSoftwaresTree = Array(Array(ISM::SoftwareDependency)).new
                    neededSoftwares = Array(ISM::SoftwareDependency).new

                    matchingSoftwaresArray.clear

                    inextricableDependency = false

                    loop do
                        currentDependenciesArray.each do |software|
                            dependencies = software.getDependencies

                            if !dependencies.empty?
                                nextDependenciesArray = nextDependenciesArray + dependencies
                                dependenciesLevelArray = dependenciesLevelArray + dependencies
                            end
                        end
                        
                        dependenciesLevelArray.uniq! { |dependency| [   dependency.name,
                                                                        dependency.version,
                                                                        dependency.options] }

                        if !dependenciesLevelArray.empty?
                            neededSoftwaresTree << dependenciesLevelArray.dup
                        end

                        if nextDependenciesArray.empty?
                            break
                        end

                        if neededSoftwaresTree.size != neededSoftwaresTree.uniq.size
                            inextricableDependency = true
                            neededSoftwaresTree = neededSoftwaresTree & neededSoftwaresTree.uniq
                            break
                        end

                        currentDependenciesArray = nextDependenciesArray.uniq

                        nextDependenciesArray.clear
                        dependenciesLevelArray.clear

                    end

                    #Retirer encore les doublons si il y a des paquets de meme nom ou version differente, ou options differentes
                    if !matching
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{wrongArgument.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice

                    elsif inextricableDependency
                        inextricableDependenciesArray = Array(ISM::SoftwareInformation).new

                        neededSoftwaresTree.each do |level|
                            level.each do |dependency|
                                matchingSoftwaresArray << dependency.getInformation
                            end
                        end

                        matchingSoftwaresArray.uniq!

                        matchingSoftwaresArray.each do |software|
                            software.dependencies.each do |dependency|
                                temporaryArray = dependency.getInformation.dependencies + software.dependencies
                                if temporaryArray.map(&.name).includes?(software.name) &&
                                    temporaryArray.map(&.name).includes?(dependency.name)
                                    inextricableDependenciesArray << software
                                end
                            end
                        end

                        if inextricableDependenciesArray.empty?
                            inextricableDependenciesArray = matchingSoftwaresArray
                        end

                        puts "#{ISM::Default::Option::SoftwareInstall::InextricableText.colorize(:yellow)}"
                        puts "\n"

                        inextricableDependenciesArray.each do |software|
                            softwareText = "#{software.name.colorize(:magenta)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
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

                    else
                        neededSoftwaresTree.reverse.each do |level|
                            level.each do |dependency|
                                matchingSoftwaresArray << dependency.getInformation
                            end
                        end
    
                        matchingSoftwaresArray.uniq!

                        puts "\n"

                        matchingSoftwaresArray.each do |software|
                            softwareText = "#{software.name.colorize(:green)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
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

                        print   "#{ISM::Default::Option::SoftwareInstall::InstallQuestion.colorize.mode(:underline)}" + 
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
                            matchingSoftwaresArray.each do |software|
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
                                file << "target.clean\n"
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
