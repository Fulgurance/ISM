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
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    userRequest = ARGV[2+Ism.debugLevel..-1].uniq
                    requestedSoftwares = Ism.getRequestedSoftwares(userRequest)

                    #No match found
                    if userRequest.size != requestedSoftwares.size
                        showNoMatchFoundMessage(userRequest, requestedSoftwares)
                        exit 1
                    end

                    #No available version found
                    if requestedSoftwares.any? {|software| software.version == ""}
                        showNoVersionAvailableMessage(requestedSoftwares)
                        exit 1
                    end

                    dependenciesTable = getDependenciesTable(requestedSoftwares)
                    neededSoftwares = getSortedDependencies(dependenciesTable)

                    showCalculationDoneMessage
                    showNeededSoftwares(neededSoftwares)
                    showInstallationQuestion

                    userAgreement = getUserAgreement

                    if userAgreement
                        startInstallationProcess(neededSoftwares)
                    end
                end
            end

            def getRequiredDependencies(software : ISM::SoftwareInformation) : Array(ISM::SoftwareDependency)
                calculationStartingTime = Time.monotonic
                frameIndex = 0
                reverseAnimation = false
                text = ISM::Default::Option::SoftwareInstall::CalculationWaitingText

                dependencies = Hash(String,ISM::SoftwareDependency).new
                currentDependencies = [software.toSoftwareDependency]
                nextDependencies = Array(ISM::SoftwareDependency).new

                loop do

                    calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                    if currentDependencies.empty?
                        break
                    end

                    currentDependencies.each do |dependency|

                        calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                        #Inextricable dependencies or need multiple version or just need to fusion options
                        if dependencies.has_key? dependency.hiddenName

                            #Inextricable dependencies
                            if dependencies[dependency.hiddenName] == dependency

                                exit 1
                            else
                                #Multiple versions of single software requested
                                if dependencies[dependency.hiddenName].version != dependency.version


                                    exit 1
                                end
                                #Versions are equal but options are differents
                                if dependencies[dependency.hiddenName].version == dependency.version



                                end
                            end
                        else
                            dependencies[dependency.hiddenName] = dependency
                            nextDependencies += dependency.dependencies
                        end

                    end

                    currentDependencies = nextDependencies.dup
                    nextDependencies.clear

                end

                return dependencies.values
            end

            def getDependenciesTable(softwareList : Array(ISM::SoftwareInformation)) : Hash(String,Array(ISM::SoftwareDependency))
                calculationStartingTime = Time.monotonic
                frameIndex = 0
                reverseAnimation = false
                text = ISM::Default::Option::SoftwareInstall::CalculationWaitingText

                dependenciesTable = Hash(String,Array(ISM::SoftwareDependency)).new

                softwareList.each do |software|
                    calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                    key = software.toSoftwareDependency.hiddenName

                    dependenciesTable[key] = getRequiredDependencies(software)

                    dependenciesTable[key].each do |dependency|
                        calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                        dependenciesTable[dependency.hiddenName] = getRequiredDependencies(dependency.information)
                    end
                end

                return dependenciesTable
            end

            def getSortedDependencies(dependenciesTable : Hash(String,Array(ISM::SoftwareDependency))) : Array(ISM::SoftwareDependency)
                calculationStartingTime = Time.monotonic
                frameIndex = 0
                reverseAnimation = false
                text = ISM::Default::Option::SoftwareInstall::CalculationWaitingText

                result = Array(ISM::SoftwareDependency).new

                dependenciesTable.to_a.sort_by { |k, v| v.size }.each do |item|
                    calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                    result << item[1][0]
                end

                return result
            end

            def showNoMatchFoundMessage(userRequest : Array(String),requestedSoftwares : Array(ISM::SoftwareInformation))
                wrongArguments = Array(String).new

                userRequest.each do |request|
                    exist = false

                    requestedSoftwares.each do |software|
                        if request == software.versionName
                            exist = true
                            break
                        end
                    end

                    if !exist
                        wrongArguments += request
                    end
                end

                puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{wrongArgument.join(", ").colorize(:green)}"
                puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                puts
                puts "#{ISM::Default::Option::SoftwareInstall::DoesntExistText.colorize(:green)}"
            end

            def showNoVersionAvailableMessage(requestedSoftwares : Array(ISM::SoftwareInformation))
                wrongArguments = Array(String).new

                requestedSoftwares.each do |software|
                    if software.version == ""
                        wrongArguments += software.versionName
                    end
                end

                puts ISM::Default::Option::SoftwareInstall::NoVersionAvailable + "#{wrongArgument.join(", ").colorize(:green)}"
                puts ISM::Default::Option::SoftwareInstall::NoVersionAvailableAdvice
                puts
                puts "#{ISM::Default::Option::SoftwareInstall::DoesntExistText.colorize(:green)}"
            end

            def showCalculationDoneMessage
                print "#{ISM::Default::Option::SoftwareInstall::CalculationDoneText.colorize(:green)}\n"
            end

            def showNeededSoftwares(neededSoftwares : Array(ISM::SoftwareDependency))
                puts "\n"

                neededSoftwares.each do |software|
                    information = software.information

                    softwareText = "#{information.name.colorize(:green)}" + " /" + "#{information.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                    optionsText = "{ "

                    information.options.each do |option|
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
            end

            def showInstallationQuestion
                summaryText = neededSoftwares.size.to_s + ISM::Default::Option::SoftwareInstall::SummaryText + "\n"

                puts "#{summaryText.colorize(:green)}"

                print   "#{ISM::Default::Option::SoftwareInstall::InstallQuestion.colorize.mode(:underline)}" +
                        "[" + "#{ISM::Default::Option::SoftwareInstall::YesReplyOption.colorize(:green)}" +
                        "/" + "#{ISM::Default::Option::SoftwareInstall::NoReplyOption.colorize(:red)}" + "]"
            end

            def getUserAgreement : Bool
                userInput = ""
                userAgreement = false

                loop do
                    userInput = gets

                    if userInput == ISM::Default::Option::SoftwareInstall::YesReplyOption
                        return true
                    end
                    if userInput == ISM::Default::Option::SoftwareInstall::NoReplyOption
                        return false
                    end
                end
            end

            def updateInstallationTerminalTitle(index : Int32, limit : Int32, name : String, version : String)
                Ism.setTerminalTitle("#{ISM::Default::CommandLine::Name}: [#{(index+1)} / #{limit}] #{ISM::Default::Option::SoftwareInstall::InstallingText} #{name} /#{version}/")
            end

            def startInstallationProcess(neededSoftwares : Array(ISM::SoftwareDependency))
                puts "\n"

                neededSoftwares.each do |software|
                    updateInstallationTerminalTitle

                end
            end

        end

    end

end
