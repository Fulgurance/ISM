module ISM

    module Option

        class SoftwareSelectDependency < ISM::CommandLineOption

            module Default

                ShortText = "-sd"
                LongText = "selectdependency"
                Description = "Select a dependency part of unique set\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism software [softwarename] selectdependency [dependencyname]"
                ShowHelpDescription = "Enable a specific software dependency"
                ShowHelpExampleText1 = "Need to be use like this:"
                ShowHelpExampleText2 = "ism software [softwarename] selectdependency [dependencyname]"
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                SetText1 = "Enabling the dependency "
                SetText2 = " for the software "
                DependencyNoMatchFound1 = "No matching dependency named "
                DependencyNoMatchFound2 = " found for the software "

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase, allowSearchByNameOnly: true)

                    if matchingSoftware.fullName == ""
                        puts Default::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                        puts Default::NoMatchFoundAdvice
                    else
                        if ARGV[2] == @shortText || ARGV[2] == @longText

                            dependency = Ism.getSoftwareInformation(ARGV[3].downcase, allowSearchByNameOnly: true)

                            dependencyText = "#{("@"+dependency.port).colorize(:red)}:#{dependency.name.colorize(:green)}"
                            matchingSoftwareText = "#{("@"+matchingSoftware.port).colorize(:red)}:#{matchingSoftware.name.colorize(:green)}"

                            if matchingSoftware.selectUniqueDependency(dependency.fullName)
                                matchingSoftware.writeConfiguration(matchingSoftware.settingsFilePath)

                                Ism.printProcessNotification(   Default::SetText1 +
                                                                dependencyText +
                                                                Default::SetText2 +
                                                                matchingSoftwareText)
                            else
                                Ism.printErrorNotification( Default::DependencyNoMatchFound1 +
                                                            dependencyText +
                                                            Default::DependencyNoMatchFound2 +
                                                            matchingSoftwareText,nil)
                            end
                        else
                            showHelp
                        end
                    end
                end

            end

            def showHelp
                puts    Default::ShowHelpDescription +
                        "\n\n\t" + Default::ShowHelpExampleText1 +
                        "\n\t" + "#{Default::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
