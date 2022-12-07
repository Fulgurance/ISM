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
                    matchingSoftwaresArray = Array(ISM::SoftwareInformation).new
                    matching = false
                    wrongArgument = ""

                    calculationStartingTime = Time.monotonic
                    frameIndex = 0
                    reverseAnimation = false

                    print ISM::Default::Option::SoftwareRemove::CalculationTitle
                    text = ISM::Default::Option::SoftwareRemove::CalculationWaitingText

                    #####################
                    #Get wanted softwares
                    #####################
                    ARGV[2+Ism.debugLevel..-1].uniq.each do |argument|

                        animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                        calculationStartingTime = animationVariables[0]
                        frameIndex = animationVariables[1]

                        matching = false

                        Ism.softwares.each do |software|

                            animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            calculationStartingTime = animationVariables[0]
                            frameIndex = animationVariables[1]

                            if argument == software.name || argument == software.name.downcase
                                matchingSoftwaresArray << software.versions.last
                                matching = true
                            else
                                software.versions.each do |version|

                                    animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                                    calculationStartingTime = animationVariables[0]
                                    frameIndex = animationVariables[1]

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

                    matchingInstalledSoftwares = false
                    matchingInstalledSoftwaresArray = Array(ISM::SoftwareInformation).new

                    #####################
                    #Get matching installed softwares
                    #####################
                    if matching
                        matchingSoftwaresArray.each do |software|

                            animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            calculationStartingTime = animationVariables[0]
                            frameIndex = animationVariables[1]

                            if Ism.softwareIsInstalled?(software)
                                matchingInstalledSoftwares = true
                                matchingInstalledSoftwaresArray << software
                            end
                        end

                        matchingSoftwaresArray.uniq!
                    end

                    uselessSoftwares = Array(ISM::SoftwareInformation).new

                    #####################
                    #Get useless softwares
                    #####################
                    if matchingInstalledSoftwares
                        Ism.installedSoftwares.each do |installedSoftwares|

                            animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                            calculationStartingTime = animationVariables[0]
                            frameIndex = animationVariables[1]

                            matchingInstalledSoftwaresArray.each do |matchingInstalledSoftwares|

                                animationVariables = Ism.playCalculationAnimation(calculationStartingTime, frameIndex, text)

                                calculationStartingTime = animationVariables[0]
                                frameIndex = animationVariables[1]

                                if !installedSoftwares.dependencies.includes?(matchingInstalledSoftwares)
                                    uselessSoftwares << matchingInstalledSoftwares
                                end
                            end
                        end

                        uselessSoftwares.uniq!
                    end
                    ##########################################

                    print "#{ISM::Default::Option::SoftwareRemove::CalculationDoneText.colorize(:green)}\n"

                    if !matching || !matchingInstalledSoftwares
                        puts ISM::Default::Option::SoftwareRemove::NoInstalledMatchFound + "#{wrongArgument.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareRemove::NoInstalledMatchFoundAdvice
                    end

                    if uselessSoftwares.size > 0

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
                                puts    "#{"<<".colorize(:light_magenta)}" +
                                        " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                                        " / "+"#{uselessSoftwares.size.to_s.colorize(:light_red)}" +
                                        "] Uninstalling "+"#{software.name.colorize(:green)}"+"\n\n"

                                targetPath =    ISM::Default::Path::InstalledSoftwaresDirectory +
                                                software.port + "/" +
                                                software.name + "/" +
                                                software.version + "/" +
                                                ISM::Default::Filename::Information

                                requirePath =   ISM::Default::Path::SoftwaresDirectory +
                                                software.port + "/" +
                                                software.name + "/" +
                                                software.version + "/" +
                                                software.version + ".cr"

                                tasks = <<-CODE
                                require "./RequiredLibraries"
                                Ism = ISM::CommandLine.new
                                Ism.loadSoftwareDatabase
                                Ism.loadSettingsFiles
                                require "./#{requirePath}"
                                target = Target.new("#{targetPath}")

                                begin
                                    target.uninstall
                                rescue
                                    exit 1
                                end

                                CODE

                                File.write("ISM.task", tasks)

                                process = Process.run("crystal",args: ["ISM.task"],output: :inherit,error: :inherit,)

                                if !process.success?
                                    break
                                end

                                FileUtils.rm_r( ISM::Default::Path::InstalledSoftwaresDirectory +
                                                software.port + "/" +
                                                software.name)

                                puts
                                puts    "#{software.name.colorize(:green)}" +
                                        " is uninstalled "+"["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                                        " / "+"#{uselessSoftwares.size.to_s.colorize(:light_red)}"+"] " +
                                        "#{">>".colorize(:light_magenta)}"+"\n\n"
                            end

                        end

                    else
                        puts
                        puts "#{ISM::Default::Option::SoftwareRemove::NotInstalledText.colorize(:green)}"
                    end

                    ##########################################
                end
            end

        end
        
    end

end
