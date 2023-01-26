module ISM

    module Option

        class SoftwareRemove < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareRemove::ShortText,
                        ISM::Default::Option::SoftwareRemove::LongText,
                        ISM::Default::Option::SoftwareRemove::Description,
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

                    print ISM::Default::Option::SoftwareRemove::CalculationTitle
                    text = ISM::Default::Option::SoftwareRemove::CalculationWaitingText

                    matching, matchingSoftwaresArray, wrongArgument, calculationStartingTime, frameIndex = Ism.getRequestedSoftwares(   ARGV[2+Ism.debugLevel..-1].uniq,
                                                                                                                                        calculationStartingTime,
                                                                                                                                        frameIndex,
                                                                                                                                        ISM::Default::Option::SoftwareInstall::CalculationWaitingText)

                    #####################
                    #Get matching installed softwares
                    #####################
                    matchingInstalledSoftwares = false
                    matchingInstalledSoftwaresArray = Array(ISM::SoftwareInformation).new

                    if matching
                        matchingSoftwaresArray.each do |software|

                            calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            if Ism.softwareIsInstalled?(software)
                                matchingInstalledSoftwares = true
                                matchingInstalledSoftwaresArray << software
                            end
                        end

                        matchingSoftwaresArray.uniq!
                    end

                    #####################
                    #Check if requested softwares are not dependencies for other softwares
                    #####################
                    requestedSoftwaresAreDependencies = false
                    requestedSoftwaresAreDependenciesArray = Array(Array(ISM::SoftwareInformation)).new

                    matchingInstalledSoftwaresArray.each do |software|

                        calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                        Ism.installedSoftwares.each do |installedSoftware|

                            calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            if installedSoftware.dependencies.includes?(software.toSoftwareDependency)
                                requestedSoftwaresAreDependencies = true
                                ##### NEW
                                requestedSoftwaresAreDependenciesArray << [installedSoftware, software]
                            end
                        end

                    end

                    uselessSoftwares = Array(ISM::SoftwareInformation).new

                    #####################
                    #Get useless softwares
                    #####################
                    if matchingInstalledSoftwares && !requestedSoftwaresAreDependencies
                        Ism.installedSoftwares.each do |installedSoftware|

                            calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            matchingInstalledSoftwaresArray.each do |matchingInstalledSoftware|

                                calculationStartingTime, frameIndex = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                                if !installedSoftware.dependencies.includes?(matchingInstalledSoftware.toSoftwareDependency)
                                    uselessSoftwares << matchingInstalledSoftware
                                end

                            end
                        end

                        uselessSoftwares.uniq!
                    end

                    print "#{ISM::Default::Option::SoftwareRemove::CalculationDoneText.colorize(:green)}\n"

                    if !matching || !matchingInstalledSoftwares
                        puts ISM::Default::Option::SoftwareRemove::NoInstalledMatchFound + "#{wrongArgument.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareRemove::NoInstalledMatchFoundAdvice
                    end

                    if requestedSoftwaresAreDependencies
                        puts ISM::Default::Option::SoftwareRemove::RequestedSoftwaresAreDependencies
                        puts "\n"

                        requestedSoftwaresAreDependenciesArray.each do |softwares|
                            softwareText1 = "#{softwares[0].name.colorize(:green)}" + " /" + "#{softwares[0].version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                            optionsText1 = "{ "
                            softwares[0].options.each do |option|
                                if option.active
                                    optionsText1 += "#{option.name.colorize(:red)}"
                                else
                                    optionsText1 += "#{option.name.colorize(:blue)}"
                                end
                                optionsText1 += " "
                            end
                            optionsText1 += "}"

                            softwareText2 = "#{softwares[1].name.colorize(:green)}" + " /" + "#{softwares[1].version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                            optionsText2 = "{ "
                            softwares[1].options.each do |option|
                                if option.active
                                    optionsText2 += "#{option.name.colorize(:red)}"
                                else
                                    optionsText2 += "#{option.name.colorize(:blue)}"
                                end
                                optionsText2 += " "
                            end
                            optionsText2 += "}"

                            puts "\t" + softwareText1 + " " + optionsText1 + ISM::Default::Option::SoftwareRemove::DependOfText + softwareText2 + " " + optionsText2 + "\n"
                        end

                        puts "\n"
                        puts ISM::Default::Option::SoftwareRemove::RequestedSoftwaresAreDependenciesAdvice
                    end

                    if uselessSoftwares.size > 0 && !requestedSoftwaresAreDependencies

                        puts "\n"

                        uselessSoftwares.each do |software|
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

                        summaryText = uselessSoftwares.size.to_s + ISM::Default::Option::SoftwareRemove::SummaryText + "\n"

                        puts "#{summaryText.colorize(:green)}"

                        print   "#{ISM::Default::Option::SoftwareRemove::UninstallQuestion.colorize.mode(:underline)}" +
                                "[" + "#{ISM::Default::Option::SoftwareRemove::YesReplyOption.colorize(:green)}" +
                                "/" + "#{ISM::Default::Option::SoftwareRemove::NoReplyOption.colorize(:red)}" + "]"

                        loop do
                            userInput = gets

                            if userInput == ISM::Default::Option::SoftwareRemove::YesReplyOption
                                userAgreement = true
                                break
                            end
                            if userInput == ISM::Default::Option::SoftwareRemove::NoReplyOption
                                break
                            end
                        end

                        if userAgreement
                            puts "\n"

                            uselessSoftwares.each_with_index do |software, index|
                                Ism.setTerminalTitle("#{ISM::Default::CommandLine::Name}: [#{(index+1)} / #{matchingSoftwaresArray.size}] #{ISM::Default::Option::SoftwareRemove::UninstallingText} #{software.name} /#{software.version}")

                                puts    "#{"<<".colorize(:light_magenta)}" +
                                        " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                                        " / "+"#{uselessSoftwares.size.to_s.colorize(:light_red)}" +
                                        "] #{ISM::Default::Option::SoftwareRemove::UninstallingText} "+"#{software.name.colorize(:green)}"+"\n\n"

                                targetPath =    Ism.settings.rootPath +
                                                ISM::Default::Path::InstalledSoftwaresDirectory +
                                                software.port + "/" +
                                                software.name + "/" +
                                                software.version + "/" +
                                                ISM::Default::Filename::Information

                                requirePath =   Ism.settings.rootPath +
                                                ISM::Default::Path::SoftwaresDirectory +
                                                software.port + "/" +
                                                software.name + "/" +
                                                software.version + "/" +
                                                software.version + ".cr"

                                #####################################TEMPORARY FIX#################################
                                #{{ read_file("/#{ISM::Default::Path::LibraryDirectory}RequiredLibraries.cr").id }}

                                tasks = <<-CODE
                                require "colorize"
                                require "file_utils"
                                require "json"
                                require "digest"
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLine.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLineOption.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLineSettings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLineSystemSettings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/CommandLinePortsSettings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Port.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/SoftwareDependency.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/SoftwareInformation.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/SoftwareOption.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Software.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/AvailableSoftware.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLine.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLineSettings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLineSystemSettings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/CommandLinePortsSettings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Filename.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Path.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Debug/Debug.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Help/Help.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/Settings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/Show/Show.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/EnableInstallByChroot/EnableInstallByChroot.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/DisableInstallByChroot/DisableInstallByChroot.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetArchitecture/SetArchitecture.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetBuildOptions/SetBuildOptions.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetMakeOptions/SetMakeOptions.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetRootPath/SetRootPath.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetSystemName/SetSystemName.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Settings/SetTargetName/SetTargetName.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Software.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/DisableOption/DisableOption.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/EnableOption/EnableOption.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Install/Install.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Remove/Remove.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Search/Search.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Synchronize/Synchronize.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Software/Update/Update.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/Port.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/Open/Open.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/Close/Close.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Port/SetTargetVersion/SetTargetVersion.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/System/System.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/System/SetLcAll/SetLcAll.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Version/Version.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Version/Show/Show.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Default/Option/Version/Switch/Switch.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Debug/Debug.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Help/Help.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/Settings.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/Show/Show.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/EnableInstallByChroot/EnableInstallByChroot.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/DisableInstallByChroot/DisableInstallByChroot.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetArchitecture/SetArchitecture.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetBuildOptions/SetBuildOptions.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetMakeOptions/SetMakeOptions.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetRootPath/SetRootPath.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetSystemName/SetSystemName.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Settings/SetTargetName/SetTargetName.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Software.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/DisableOption/DisableOption.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/EnableOption/EnableOption.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Install/Install.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Remove/Remove.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Search/Search.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Synchronize/Synchronize.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Software/Update/Update.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/Port.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/Open/Open.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/Close/Close.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Port/SetTargetVersion/SetTargetVersion.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/System/System.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/System/SetLcAll/SetLcAll.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Version/Version.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Version/Show/Show.cr").id }}
                                {{ read_file("/#{ISM::Default::Path::LibraryDirectory}ISM/Option/Version/Switch/Switch.cr").id }}
                                Ism = ISM::CommandLine.new
                                Ism.loadSoftwareDatabase
                                Ism.loadSettingsFiles

                                {{ read_file("#{requirePath}").id }}
                                target = Target.new("#{targetPath}")

                                begin
                                    target.uninstall
                                rescue
                                    exit 1
                                end

                                CODE

                                File.write("#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)#####################EXPERIMENTAL (add .cr)


                                #######################EXPERIMENTAL (Task compilation) #######################

                                #process = Process.run("crystal",args: ["#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}"],
                                                                #output: :inherit,
                                                                #error: :inherit,)

                                #COMPILE THE TASK
                                process = Process.run("crystal",args: [ "build",
                                                                        "#{ISM::Default::Filename::Task}.cr",
                                                                        "-o",
                                                                        "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}"],
                                                                output: :inherit,
                                                                error: :inherit,
                                                                chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                                #RUN THE TASK
                                process = Process.run("./#{ISM::Default::Filename::Task}",  output: :inherit,
                                                                                            error: :inherit,
                                                                                            chdir: "#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

                                ##############################################################################

                                if !process.success?
                                    break
                                end

                                FileUtils.rm_r( Ism.settings.rootPath +
                                                ISM::Default::Path::InstalledSoftwaresDirectory +
                                                software.port + "/" +
                                                software.name)

                                puts
                                puts    "#{software.name.colorize(:green)}" +
                                        " #{ISM::Default::Option::SoftwareRemove::UninstalledText} "+"["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                                        " / "+"#{uselessSoftwares.size.to_s.colorize(:light_red)}"+"] " +
                                        "#{">>".colorize(:light_magenta)}"+"\n\n"
                            end

                        end

                    else
                        puts
                        if requestedSoftwaresAreDependencies
                            puts "#{ISM::Default::Option::SoftwareRemove::RequestedSoftwaresAreDependenciesText.colorize(:green)}"
                        else
                            puts "#{ISM::Default::Option::SoftwareRemove::NotInstalledText.colorize(:green)}"
                        end
                    end

                end
            end

        end
        
    end

end
