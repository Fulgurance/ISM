module ISM

    module Option

        class SoftwareInstall < ISM::CommandLineOption

            @@calculationStartingTime = Time.monotonic
            @@frameIndex = 0
            @@reverseAnimation = false
            @@text = ISM::Default::Option::SoftwareInstall::CalculationWaitingText
            @@requestedSoftwares = Array(ISM::SoftwareInformation).new

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
                    @@requestedSoftwares = Ism.getRequestedSoftwares(userRequest)

                    #No match found
                    if userRequest.size != @@requestedSoftwares.size
                        wrongArguments = Array(String).new

                        userRequest.each do |request|
                            exist = false

                            @@requestedSoftwares.each do |software|
                                if request == software.versionName
                                    exist = true
                                    break
                                end
                            end

                            if !exist
                                wrongArguments.push(request)
                            end
                        end

                        showNoMatchFoundMessage(wrongArguments)
                        Ism.exitProgram
                    end

                    #No available version found
                    if @@requestedSoftwares.any? {|software| software.version == ""}
                        wrongArguments = Array(String).new

                        @@requestedSoftwares.each do |software|
                            if software.version == ""
                                wrongArguments.push(software.versionName)
                            end
                        end

                        showNoVersionAvailableMessage(wrongArguments)
                        Ism.exitProgram
                    end

                    showCalculationTitleMessage

                    dependenciesTable = getDependenciesTable(@@requestedSoftwares)
                    neededSoftwares = getSortedDependencies(dependenciesTable)

                    showCalculationDoneMessage
                    showNeededSoftwares(neededSoftwares)
                    showInstallationQuestion(neededSoftwares.size)

                    userAgreement = getUserAgreement

                    if userAgreement
                        startInstallationProcess(neededSoftwares)
                    end
                end
            end

            def getRequiredDependencies(software : ISM::SoftwareInformation) : Array(ISM::SoftwareDependency)
                dependencies = Hash(String,ISM::SoftwareDependency).new
                currentDependencies = [software.toSoftwareDependency]
                nextDependencies = Array(ISM::SoftwareDependency).new

                dependenciesTree = [[software.toSoftwareDependency]]

                loop do

                    @@calculationStartingTime, @@frameIndex, @@reverseAnimation = Ism.playCalculationAnimation(@@calculationStartingTime, @@frameIndex, @@reverseAnimation, @@text)

                    currentLevelDependenciesTree = Array(ISM::SoftwareDependency).new

                    if currentDependencies.empty?
                        break
                    end

                    currentDependencies.each do |dependency|
                        @@calculationStartingTime, @@frameIndex, @@reverseAnimation = Ism.playCalculationAnimation(@@calculationStartingTime, @@frameIndex, @@reverseAnimation, @@text)

                        dependencyInformation = dependency.information

                        #Software not available
                        if dependencyInformation.name == ""
                            showCalculationDoneMessage
                            showUnavailableDependencyMessage(dependency)
                            Ism.exitProgram
                        end

                        #Version not available
                        if dependencyInformation.version == ""
                            showCalculationDoneMessage
                            showUnavailableDependencyMessage(dependency)
                            Ism.exitProgram
                        end

                        #Need multiple version or need to fusion options
                        if dependencies.has_key?(dependency.hiddenName)

                            #Multiple versions of single software requested
                            if dependencies[dependency.hiddenName].version != dependency.version

                                #Ism.exitProgram
                            end
                            #Versions are equal but options are differents
                            if dependencies[dependency.hiddenName].version == dependency.version


                            end
                        else
                            dependencies[dependency.hiddenName] = dependency
                            nextDependencies += dependency.dependencies
                        end

                        currentLevelDependenciesTree = currentLevelDependenciesTree+dependency.dependencies

                    end

                    #Inextricable dependencies problem
                    dependenciesTree.each do |branch|
                        @@calculationStartingTime, @@frameIndex, @@reverseAnimation = Ism.playCalculationAnimation(@@calculationStartingTime, @@frameIndex, @@reverseAnimation, @@text)

                        if branch.size == currentLevelDependenciesTree.size && branch & currentLevelDependenciesTree == branch
                            showCalculationDoneMessage
                            showInextricableDependenciesMessage(currentLevelDependenciesTree)
                            Ism.exitProgram
                        end
                    end

                    dependenciesTree.push(currentLevelDependenciesTree.uniq)

                    currentDependencies = nextDependencies.dup
                    nextDependencies.clear

                end

                return dependencies.values
            end

            def getDependenciesTable(softwareList : Array(ISM::SoftwareInformation)) : Hash(String,Array(ISM::SoftwareDependency))
                dependenciesTable = Hash(String,Array(ISM::SoftwareDependency)).new

                softwareList.each do |software|
                    @@calculationStartingTime, @@frameIndex, @@reverseAnimation = Ism.playCalculationAnimation(@@calculationStartingTime, @@frameIndex, @@reverseAnimation, @@text)

                    key = software.toSoftwareDependency.hiddenName

                    dependenciesTable[key] = getRequiredDependencies(software)

                    dependenciesTable[key].each do |dependency|
                        @@calculationStartingTime, @@frameIndex, @@reverseAnimation = Ism.playCalculationAnimation(@@calculationStartingTime, @@frameIndex, @@reverseAnimation, @@text)

                        dependencyInformation = dependency.information

                        if !Ism.softwareIsInstalled(dependencyInformation)
                            dependenciesTable[dependency.hiddenName] = getRequiredDependencies(dependencyInformation)
                        end
                    end
                end

                return dependenciesTable
            end

            def getSortedDependencies(dependenciesTable : Hash(String,Array(ISM::SoftwareDependency))) : Array(ISM::SoftwareDependency)
                result = Array(ISM::SoftwareDependency).new

                dependenciesTable.to_a.sort_by { |k, v| v.size }.each do |item|
                    @@calculationStartingTime, @@frameIndex, @@reverseAnimation = Ism.playCalculationAnimation(@@calculationStartingTime, @@frameIndex, @@reverseAnimation, @@text)

                    result << item[1][0]
                end

                resultedSoftwareNames = result.map { |dependency| dependency.name }
                requestedSoftwareNames = @@requestedSoftwares.map { |software| software.name }

                if !requestedSoftwareNames.includes?(requestedSoftwareNames[-1])
                    dependenciesAtUpperLevelList = Array(ISM::SoftwareDependency).new

                    result.reverse.each do |dependency|
                        if requestedSoftwareNames.includes?(dependency.name)
                            break
                        else
                            dependenciesAtUpperLevelList.push(dependency)
                        end
                    end

                    showCalculationDoneMessage
                    showDependenciesAtUpperLevelMessage(dependenciesAtUpperLevelList)
                    Ism.exitProgram
                end

                return result
            end

            def showNoMatchFoundMessage(wrongArguments : Array(String))
                puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{wrongArguments.join(", ").colorize(:green)}"
                puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                puts
                puts "#{ISM::Default::Option::SoftwareInstall::DoesntExistText.colorize(:green)}"
            end

            def showNoVersionAvailableMessage(wrongArguments : Array(String))
                puts ISM::Default::Option::SoftwareInstall::NoVersionAvailable + "#{wrongArguments.join(", ").colorize(:green)}"
                puts ISM::Default::Option::SoftwareInstall::NoVersionAvailableAdvice
                puts
                puts "#{ISM::Default::Option::SoftwareInstall::DoesntExistText.colorize(:green)}"
            end

            def showUnavailableDependencyMessage(dependency : ISM::SoftwareDependency)
                puts "#{ISM::Default::Option::SoftwareInstall::UnavailableText.colorize(:yellow)}"
                puts "\n"

                softwareText = "#{dependency.name.colorize(:magenta)}" + " /" + "#{dependency.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                optionsText = "{ "

                dependency.information.options.each do |option|
                    if option.active
                        optionsText += "#{option.name.colorize(:red)}"
                    else
                        optionsText += "#{option.name.colorize(:blue)}"
                    end
                    optionsText += " "
                end
                optionsText += "}"
                puts "\t" + softwareText + " " + optionsText + "\n"

                puts "\n"
            end

            def showInextricableDependenciesMessage(dependencies : Array(ISM::SoftwareDependency))
                puts "#{ISM::Default::Option::SoftwareInstall::InextricableText.colorize(:yellow)}"
                puts "\n"

                dependencies.each do |software|
                    softwareText = "#{software.name.colorize(:magenta)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                    optionsText = "{ "

                    software.information.options.each do |option|
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

            def showDependenciesAtUpperLevelMessage(dependencies : Array(ISM::SoftwareDependency))
                puts "#{ISM::Default::Option::SoftwareInstall::DependenciesAtUpperLevelText.colorize(:yellow)}"
                puts "\n"

                dependencies.each do |software|
                    softwareText = "#{software.name.colorize(:magenta)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                    optionsText = "{ "

                    software.information.options.each do |option|
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

            def showCalculationTitleMessage
                print "#{ISM::Default::Option::SoftwareInstall::CalculationTitle}"
            end

            def showCalculationDoneMessage
                Ism.cleanCalculationAnimation(@@frameIndex)
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

            def showInstallationQuestion(softwareNumber : Int32)
                summaryText = softwareNumber.to_s + ISM::Default::Option::SoftwareInstall::SummaryText + "\n"

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
                Ism.setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::Option::SoftwareInstall::InstallingText} #{name} /#{version}/")
            end

            def showStartSoftwareInstallingMessage(index : Int32, limit : Int32, name : String, version : String)
                puts    "#{"<<".colorize(:light_magenta)}" +
                        " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                        " / #{limit.to_s.colorize(:light_red)}" +
                        "] #{ISM::Default::Option::SoftwareInstall::InstallingText} " +
                        "#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                        "\n\n"
            end

            def showEndSoftwareInstallingMessage(index : Int32, limit : Int32, name : String, version : String)
                puts
                puts    "#{name.colorize(:green)}" +
                        " #{ISM::Default::Option::SoftwareInstall::InstalledText} " +
                        "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                        " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                        "#{">>".colorize(:light_magenta)}" +
                        "\n\n"
            end

            def cleanBuildingDirectory(path : String)
                if Dir.exists?(path)
                    FileUtils.rm_r(path)
                end

                Dir.mkdir_p(path)
            end

            def getRequiredLibraries : String
                requireFileContent = File.read_lines("/#{ISM::Default::Path::LibraryDirectory}#{ISM::Default::Filename::RequiredLibraries}")
                requiredLibraries = String.new

                requireFileContent.each do |line|
                    if line.includes?("require \".")
                        newLine = line.gsub("require \".","{{ read_file(\"/#{ISM::Default::Path::LibraryDirectory}")+"\n"
                        newLine = newLine.insert(-3,".cr")+").id }}"+"\n"
                        requiredLibraries += newLine
                    else
                        requiredLibraries += line+"\n"
                    end
                end

                return requiredLibraries
            end

            def getEnabledOptions(software : ISM::SoftwareDependency) : String
                requiredOptions = String.new

                software.information.options.each do |option|
                    if option.active
                        requiredOptions += "target.information.enableOption(\"#{option.name}\")\n"
                    else
                        requiredOptions += "target.information.disableOption(\"#{option.name}\")\n"
                    end
                end

                return requiredOptions
            end

            def generateTasks(software : ISM::SoftwareDependency) : String
                tasks = <<-CODE
                        #{getRequiredLibraries}
                        Ism = ISM::CommandLine.new
                        Ism.loadSoftwareDatabase
                        Ism.loadSettingsFiles
                        {{ read_file("#{software.requireFilePath}").id }}
                        target = Target.new("#{software.filePath}")
                        #{getEnabledOptions(software)}
                        begin
                            target.download
                            target.check
                            target.extract
                            target.patch
                            target.prepare
                            target.configure
                            target.build
                            target.prepareInstallation
                            target.install
                            target.clean
                            target.showInformations
                        rescue
                            Ism.exitProgram
                        end

                        CODE

                return tasks
            end

            def generateTasksFile(tasks : String)
                File.write("#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)
            end

            def makeLogDirectory(path : String)
                if !Dir.exists?(path)
                    Dir.mkdir_p(path)
                end
            end

            def runInstallationProcess(software : ISM::SoftwareDependency)
                cleanBuildingDirectory(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)

                tasks = generateTasks(software)
                generateTasksFile(tasks)

                makeLogDirectory("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}")
                logFile = File.open("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}/#{software.versionName}.log","w")
                logWriter = IO::MultiWriter.new(STDOUT,logFile)

                process = Process.run("crystal",args: [ "build",
                                                        "#{ISM::Default::Filename::Task}.cr",
                                                        "-o",
                                                        "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}"],
                                                output: logWriter,
                                                error: logWriter,
                                                chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                if !process.success?
                    Ism.exitProgram
                end

                process = Process.run("./#{ISM::Default::Filename::Task}",  output: logWriter,
                                                                            error: logWriter,
                                                                            chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                logFile.close

                if !process.success?
                    Ism.exitProgram
                end

                cleanBuildingDirectory(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)
            end

            def startInstallationProcess(neededSoftwares : Array(ISM::SoftwareDependency))
                puts "\n"

                neededSoftwares.each_with_index do |software, index|
                    limit = neededSoftwares.size
                    name = software.name
                    version = software.version

                    updateInstallationTerminalTitle(index, limit, name, version)

                    showStartSoftwareInstallingMessage(index, limit, name, version)

                    runInstallationProcess(software)

                    showEndSoftwareInstallingMessage(index, limit, name, version)
                end
            end

        end

    end

end
