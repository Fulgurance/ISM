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
                    ####Doit tenir compte des configs ?
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

                    #####################
                    #Get dependencies array by level
                    #####################
                    currentDependenciesArray = Array(ISM::SoftwareDependency).new
                    currentDependenciesArray = matchingSoftwaresArray
                    nextDependenciesArray = Array(ISM::SoftwareDependency).new
                    dependencies = Array(ISM::SoftwareDependency).new
                    dependenciesLevelArray = Array(ISM::SoftwareDependency).new
                    neededSoftwaresTree = Array(Array(ISM::SoftwareDependency)).new
                    neededSoftwares = Array(ISM::SoftwareDependency).new

                    while 0
                        
                        #Ajouter un nouveau tableau pour checker les doublons sur chaque niveau
                        #avec les dependances precedemment ajoutees

                        currentDependenciesArray.each do |software|
                            dependencies = Ism.getDependencies(software.name,software.version)

                            if !dependencies.empty?
                                nextDependenciesArray = nextDependenciesArray + dependencies
                                dependenciesLevelArray = dependenciesLevelArray + dependencies
                                #Checker les options et si elles sont actives par defaut
                            end
                        end
                        
                        #Remove duplicate elements for each level
                        dependenciesLevelArray.uniq! { |dependency| [   dependency.name,
                                                                        dependency.version,
                                                                        dependency.options] }

                        if !dependenciesLevelArray.empty?
                            neededSoftwaresTree << dependenciesLevelArray.dup
                        end

                        if nextDependenciesArray.empty?
                            break
                        end

                        currentDependenciesArray = nextDependenciesArray.uniq
                        nextDependenciesArray.clear
                        dependenciesLevelArray.clear

                    end

                    neededSoftwaresTree

                    neededSoftwaresTree.each do |level|
                        level.each do |dependency|
                            neededSoftwares << dependency
                        end
                    end
                    
                    neededSoftwares.uniq! { |dependency| [  dependency.name,
                                                            dependency.version,
                                                            dependency.options] }

                    neededSoftwares.each do |software|
                        matchingSoftwaresArray.unshift(Ism.getDependencyInformation(software.name, software.version))
                    end

                    #Retirer encore les doublons si il y a des paquets de meme nom ou version, ou version differente, ou options differentes
                    #Retirer les doublons avec les logiciels saisies par l'utilisateur

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
