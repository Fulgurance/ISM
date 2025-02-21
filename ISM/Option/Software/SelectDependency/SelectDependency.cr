module ISM

    module Option

        class SoftwareSelectDependency < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSelectDependency::ShortText,
                        ISM::Default::Option::SoftwareSelectDependency::LongText,
                        ISM::Default::Option::SoftwareSelectDependency::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase, allowSearchByNameOnly: true)

                    if matchingSoftware.fullName == ""
                        puts ISM::Default::Option::SoftwareSelectDependency::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareSelectDependency::NoMatchFoundAdvice
                    else
                        if ARGV[2] == @shortText || ARGV[2] == @longText

                            dependency = Ism.getSoftwareInformation(ARGV[3].downcase, allowSearchByNameOnly: true)

                            dependencyText = "#{("@"+dependency.port).colorize(:red)}:#{dependency.name.colorize(:green)}"
                            matchingSoftwareText = "#{("@"+matchingSoftware.port).colorize(:red)}:#{matchingSoftware.name.colorize(:green)}"

                            if matchingSoftware.selectUniqueDependency(dependency.fullName)
                                matchingSoftware.writeConfiguration(matchingSoftware.settingsFilePath)

                                Ism.printProcessNotification(   ISM::Default::Option::SoftwareSelectDependency::SetText1 +
                                                                dependencyText +
                                                                ISM::Default::Option::SoftwareSelectDependency::SetText2 +
                                                                matchingSoftwareText)
                            else
                                Ism.printErrorNotification( ISM::Default::Option::SoftwareSelectDependency::DependencyNoMatchFound1 +
                                                            dependencyText +
                                                            ISM::Default::Option::SoftwareSelectDependency::DependencyNoMatchFound2 +
                                                            matchingSoftwareText,nil)
                            end
                        else
                            showHelp
                        end
                    end
                end

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareSelectDependency::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareSelectDependency::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareSelectDependency::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
