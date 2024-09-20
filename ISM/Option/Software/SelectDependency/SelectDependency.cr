module ISM

    module Option

        class SoftwareSelectDependency < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSelectDependency::ShortText,
                        ISM::Default::Option::SoftwareSelectDependency::LongText,
                        ISM::Default::Option::SoftwareSelectDependency::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel || ARGV.size == 3+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        matchingSoftware = Ism.getSoftwareInformation(ARGV[1+Ism.debugLevel].downcase)

                        if matchingSoftware.fullName == ""
                            puts ISM::Default::Option::SoftwareSelectDependency::NoMatchFound + "#{ARGV[1+Ism.debugLevel].colorize(:green)}"
                            puts ISM::Default::Option::SoftwareSelectDependency::NoMatchFoundAdvice
                        else
                            if ARGV[2+Ism.debugLevel] == @shortText || ARGV[2+Ism.debugLevel] == @longText

                                dependency = ARGV[3+Ism.debugLevel].downcase

                                dependencyText = "#{dependency[0..dependency.index(":")].titleize.colorize(:red)}#{dependency.gsub(dependency[0..dependency.index(":")],"").titleize.colorize(:green)}"
                                matchingSoftwareText = "#{("@"+matchingSoftware.port+":").colorize(:red)}#{matchingSoftware.name.colorize(:green)}"

                                if matchingSoftware.selectUniqueDependency(dependency)
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

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareSelectDependency::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareSelectDependency::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareSelectDependency::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
