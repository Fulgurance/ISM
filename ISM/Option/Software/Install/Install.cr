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
                    wrongArgument = ""

                    calculationStartingTime = Time.monotonic
                    frameIndex = 0

                    print ISM::Default::Option::SoftwareInstall::CalculationTitle
                    text = ISM::Default::Option::SoftwareInstall::CalculationWaitingText

                    matching, matchingSoftwaresArray, wrongArgument, calculationStartingTime, frameIndex = Ism.getRequestedSoftwares(   ARGV[2+Ism.debugLevel..-1].uniq,
                                                                                                                                        calculationStartingTime,
                                                                                                                                        frameIndex,
                                                                                                                                        ISM::Default::Option::SoftwareInstall::CalculationWaitingText)

                    ################################
                    #Get dependencies array by level
                    ################################
                    currentDependenciesArray = Array(ISM::SoftwareDependency).new

                    matchingSoftwaresArray.each do |software|

                        calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

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

                        calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                        currentDependenciesArray.each do |software|

                            animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            calculationStartingTime = animationVariables[0]
                            frameIndex = animationVariables[1]

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
                                if !Ism.softwareIsInstalled?(dependency.getInformation)
                                    matchingSoftwaresArray << dependency.getInformation
                                end
                            end
                        end

                        matchingSoftwaresArray.uniq!

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

                                    if File.exists?(Ism.settings.rootPath +
                                                    ISM::Default::Path::SettingsSoftwaresDirectory +
                                                    software.name + "/" +
                                                    software.version + "/" +
                                                    ISM::Default::Filename::SoftwareSettings)
                                        targetPath =    Ism.settings.rootPath +
                                                        ISM::Default::Path::SettingsSoftwaresDirectory +
                                                        software.name + "/" +
                                                        software.version + "/" +
                                                        ISM::Default::Filename::SoftwareSettings
                                    else
                                        targetPath =    Ism.settings.rootPath +
                                                        ISM::Default::Path::SoftwaresDirectory +
                                                        software.port + "/" +
                                                        software.name + "/" +
                                                        software.version + "/" +
                                                        ISM::Default::Filename::Information
                                    end

                                    requirePath =   Ism.settings.rootPath +
                                                    ISM::Default::Path::SoftwaresDirectory +
                                                    software.port + "/" +
                                                    software.name + "/" +
                                                    software.version + "/" +
                                                    software.version + ".cr"

                                    if Dir.exists?(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)
                                        FileUtils.rm_r(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)
                                    end

                                    Dir.mkdir_p(Ism.settings.rootPath+software.builtSoftwareDirectoryPath)

                                    #####################################TEMPORARY FIX#################################
                                    #{{ read_file("/#{ISM::Default::Path::LibraryDirectory}RequiredLibraries.cr").id }}

                                    tasks = <<-CODE
                                    require "colorize"
                                    require "file_utils"
                                    require "json"
                                    require "digest"
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLine").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLineOption").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLineSettings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLineSystemSettings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLinePortsSettings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Port").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/SoftwareDependency").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/SoftwareInformation").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/SoftwareOption").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Software").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/AvailableSoftware").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLine").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLineSettings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLineSystemSettings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLinePortsSettings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Filename").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Path").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Debug/Debug").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Help/Help").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/Settings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/Show/Show").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/EnableInstallByChroot/EnableInstallByChroot").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/DisableInstallByChroot/DisableInstallByChroot").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetArchitecture/SetArchitecture").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetBuildOptions/SetBuildOptions").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetMakeOptions/SetMakeOptions").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetRootPath/SetRootPath").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetSystemName/SetSystemName").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetTargetName/SetTargetName").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Software").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/DisableOption/DisableOption").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/EnableOption/EnableOption").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Install/Install").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Remove/Remove").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Search/Search").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Synchronize/Synchronize").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Update/Update").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/Port").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/Open/Open").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/Close/Close").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/SetTargetVersion/SetTargetVersion").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/System/System").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/System/SetLcAll/SetLcAll").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Version/Version").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Version/Show/Show").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Version/Switch/Switch").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Debug/Debug").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Help/Help").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/Settings").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/Show/Show").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/EnableInstallByChroot/EnableInstallByChroot").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/DisableInstallByChroot/DisableInstallByChroot").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetArchitecture/SetArchitecture").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetBuildOptions/SetBuildOptions").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetMakeOptions/SetMakeOptions").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetRootPath/SetRootPath").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetSystemName/SetSystemName").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetTargetName/SetTargetName").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Software").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/DisableOption/DisableOption").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/EnableOption/EnableOption").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Install/Install").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Remove/Remove").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Search/Search").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Synchronize/Synchronize").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Update/Update").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/Port").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/Open/Open").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/Close/Close").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/SetTargetVersion/SetTargetVersion").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/System/System").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/System/SetLcAll/SetLcAll").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Version/Version").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Version/Show/Show").id }}
                                    {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Version/Switch/Switch").id }}
                                    Ism = ISM::CommandLine.new
                                    Ism.loadSoftwareDatabase
                                    Ism.loadSettingsFiles

                                    {{ read_file("#{requirePath}").id }}
                                    target = Target.new("#{targetPath}")

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
                                    rescue
                                        exit 1
                                    end

                                    CODE

                                    File.write("#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)#####################EXPERIMENTAL (add .cr)

                                    if !Dir.exists?("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}")
                                        Dir.mkdir_p("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}")
                                    end

                                    logFile = File.open("#{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}/#{software.versionName}.log","w")

                                    writer = IO::MultiWriter.new(STDOUT,logFile)

                                    #######################EXPERIMENTAL (Task compilation) #######################

                                    #process = Process.run("crystal",args: ["#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}"],
                                                                    #output: writer,
                                                                    #error: writer)

                                    #COMPILE THE TASK
                                    process = Process.run("crystal",args: [ "build",
                                                                            "#{ISM::Default::Filename::Task}.cr",
                                                                            "-o",
                                                                            "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}"],
                                                                    output: writer,
                                                                    error: writer,
                                                                    chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                                    #RUN THE TASK
                                    process = Process.run("./#{ISM::Default::Filename::Task}",  output: writer,
                                                                                                error: writer,
                                                                                                chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                                    ##############################################################################

                                    logFile.close

                                    if !process.success?
                                        break
                                    end

                                    builtSoftwareFilesList = Dir.glob("#{software.builtSoftwareDirectoryPath}**/*")
                                    installedFiles = Array(String).new

                                    builtSoftwareFilesList.each do |entry|
                                        finalDestination = entry.delete_at(0,software.builtSoftwareDirectoryPath.size+Ism.settings.rootPath.size)# -1 ? (A cause de l'ajout de /)
                                        if File.file?(entry)
                                            installedFiles << finalDestination
                                        end
                                    end

                                    Ism.addInstalledSoftware(targetPath, installedFiles)

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
