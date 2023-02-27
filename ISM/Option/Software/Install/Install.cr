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
                    matching = false
                    unavailableSoftware = false
                    unavailableSoftwaresArray = Array(ISM::SoftwareDependency).new
                    wrongArgument = ""

                    calculationStartingTime = Time.monotonic
                    frameIndex = 0
                    reverseAnimation = false

                    print ISM::Default::Option::SoftwareInstall::CalculationTitle
                    text = ISM::Default::Option::SoftwareInstall::CalculationWaitingText

                    matching, matchingSoftwaresArray, wrongArgument, calculationStartingTime, frameIndex, reverseAnimation = Ism.getRequestedSoftwares(   ARGV[2+Ism.debugLevel..-1].uniq,
                                                                                                                                        calculationStartingTime,
                                                                                                                                        frameIndex,
                                                                                                                                        reverseAnimation,
                                                                                                                                        ISM::Default::Option::SoftwareInstall::CalculationWaitingText)

                    #################################
                    #Get dependencies array by level#
                    #################################
                    currentDependenciesArray = Array(ISM::SoftwareDependency).new

                    matchingSoftwaresArray.each do |software|

                        calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                        currentDependency = software.toSoftwareDependency
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

                        calculationStartingTime, frameIndex, reverseAnimation = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                        currentDependenciesArray.each do |software|

                            animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)

                            calculationStartingTime = animationVariables[0]
                            frameIndex = animationVariables[1]
                            reverseAnimation = animationVariables[2]

                            dependencies = software.dependencies

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

                    if !inextricableDependency
                        neededSoftwaresTree.reverse.each do |level|
                            level.each do |dependency|
                                dependencyInformation = dependency.information
                                if !Ism.softwareIsInstalled(dependencyInformation)
                                    if dependencyInformation.name != ""
                                        matchingSoftwaresArray << dependencyInformation
                                    else
                                        unavailableSoftwaresArray << dependency
                                        unavailableSoftware = true
                                    end
                                end
                            end
                        end

                        unavailableSoftware ? unavailableSoftwaresArray.uniq! : matchingSoftwaresArray.uniq!
                    end

                    print "#{ISM::Default::Option::SoftwareInstall::CalculationDoneText.colorize(:green)}\n"

                    #Retirer encore les doublons si il y a des paquets de meme nom ou version differente, ou options differentes
                    if !matching
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFound + "#{wrongArgument.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareInstall::NoMatchFoundAdvice
                        puts
                        puts "#{ISM::Default::Option::SoftwareInstall::DoesntExistText.colorize(:green)}"

                    elsif inextricableDependency
                        inextricableDependenciesArray = Array(ISM::SoftwareInformation).new

                        neededSoftwaresTree.each do |level|
                            level.each do |dependency|
                                matchingSoftwaresArray << dependency.information
                            end
                        end

                        matchingSoftwaresArray.uniq!

                        matchingSoftwaresArray.each do |software|
                            software.dependencies.each do |dependency|
                                temporaryArray = dependency.information.dependencies + software.dependencies
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

                    elsif unavailableSoftware

                        puts "#{ISM::Default::Option::SoftwareInstall::UnavailableText.colorize(:yellow)}"
                        puts "\n"

                        unavailableSoftwaresArray.each do |software|
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

                    else

                        if matchingSoftwaresArray.size > 0

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

                            summaryText = matchingSoftwaresArray.size.to_s + ISM::Default::Option::SoftwareInstall::SummaryText + "\n"

                            puts "#{summaryText.colorize(:green)}"

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
                                puts "\n"

                                matchingSoftwaresArray.each_with_index do |software, index|
                                    Ism.setTerminalTitle("#{ISM::Default::CommandLine::Name}: [#{(index+1)} / #{matchingSoftwaresArray.size}] #{ISM::Default::Option::SoftwareInstall::InstallingText} #{software.name} /#{software.version}")

                                    puts    "#{"<<".colorize(:light_magenta)}" +
                                            " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                                            " / "+"#{matchingSoftwaresArray.size.to_s.colorize(:light_red)}" +
                                            "] #{ISM::Default::Option::SoftwareInstall::InstallingText} "+"#{software.name.colorize(:green)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/"+"\n\n"

                                    if File.exists?(software.settingsFilePath)
                                        targetPath = software.settingsFilePath
                                    else
                                        targetPath = software.filePath
                                    end

                                    requirePath = software.requireFilePath

                                    if Dir.exists?(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)
                                        FileUtils.rm_r(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)
                                    end

                                    Dir.mkdir_p(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)

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

                                    requiredOptions = String.new
                                    software.options.each do |option|
                                        if option.active
                                            requiredOptions += "target.information.enableOption(\"#{option.name}\")\n"
                                        else
                                            requiredOptions += "target.information.disableOption(\"#{option.name}\")\n"
                                        end
                                    end

                                    tasks = <<-CODE
                                    #{requiredLibraries}
                                    Ism = ISM::CommandLine.new
                                    Ism.loadSoftwareDatabase
                                    Ism.loadSettingsFiles

                                    {{ read_file("#{requirePath}").id }}
                                    target = Target.new("#{targetPath}")
                                    #{requiredOptions}

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
                                        exit 1
                                    end

                                    CODE

                                    File.write("#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)

                                    if !Dir.exists?("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}")
                                        Dir.mkdir_p("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}")
                                    end

                                    logFile = File.open("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}/#{software.versionName}.log","w")

                                    writer = IO::MultiWriter.new(STDOUT,logFile)

                                    process = Process.run("crystal",args: [ "build",
                                                                            "#{ISM::Default::Filename::Task}.cr",
                                                                            "-o",
                                                                            "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}"],
                                                                    output: writer,
                                                                    error: writer,
                                                                    chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                                    process = Process.run("./#{ISM::Default::Filename::Task}",  output: writer,
                                                                                                error: writer,
                                                                                                chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                                    logFile.close

                                    if !process.success?
                                        break
                                    end

                                    builtSoftwareFilesList = Dir.glob("#{Ism.settings.rootPath}#{software.builtSoftwareDirectoryPath}**/*", match_hidden: true)
                                    installedFiles = Array(String).new

                                    builtSoftwareFilesList.each do |entry|
                                        finalDestination = entry.delete_at(0,Ism.settings.rootPath.size+software.builtSoftwareDirectoryPath.size+Ism.settings.rootPath.size-2)
                                        if File.file?(entry)
                                            installedFiles << finalDestination
                                        end
                                    end

                                    Ism.addInstalledSoftware(software, installedFiles)

                                    FileUtils.rm_r(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)

                                    puts
                                    puts    "#{software.name.colorize(:green)}" +
                                            " #{ISM::Default::Option::SoftwareInstall::InstalledText} "+"["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                                            " / "+"#{matchingSoftwaresArray.size.to_s.colorize(:light_red)}"+"] " +
                                            "#{">>".colorize(:light_magenta)}"+"\n\n"
                                end

                            end

                        else
                            puts
                            puts "#{ISM::Default::Option::SoftwareInstall::AlreadyInstalledText.colorize(:green)}"
                        end

                    end

                end
            end

        end

    end

end
