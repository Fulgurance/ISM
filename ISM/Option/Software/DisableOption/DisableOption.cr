module ISM

    module Option

        class SoftwareDisableOption < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareDisableOption::ShortText,
                        ISM::Default::Option::SoftwareDisableOption::LongText,
                        ISM::Default::Option::SoftwareDisableOption::Description)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel || ARGV.size == 3+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        matchingSoftware = Ism.getSoftwareInformation(ARGV[1+Ism.debugLevel].downcase)

                        if matchingSoftware == ""
                            puts ISM::Default::Option::SoftwareDisableOption::NoMatchFound + "#{ARGV[1+Ism.debugLevel].colorize(:green)}"
                            puts ISM::Default::Option::SoftwareDisableOption::NoMatchFoundAdvice
                        else
                            if ARGV[2+Ism.debugLevel] == @shortText || ARGV[2+Ism.debugLevel] == @longText
                                match = false
                                matchingOption = ISM::SoftwareOption.new

                                matchingSoftware.options.each do |option|
                                    if ARGV[3+Ism.debugLevel] == option.name || ARGV[3+Ism.debugLevel] == option.name.downcase
                                        matchingSoftware.disableOption(option.name)
                                        matchingOption = option
                                        match = true
                                    end
                                end

                                if match
                                    matchingSoftware.writeInformationFile(matchingSoftware.settingsFilePath)
                                    Ism.printProcessNotification(   ISM::Default::Option::SoftwareDisableOption::SetText1 +
                                                                matchingOption.name +
                                                                ISM::Default::Option::SoftwareDisableOption::SetText2 +
                                                                matchingSoftware.name)
                                else
                                    Ism.printErrorNotification( ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound1 +
                                                            ARGV[3+Ism.debugLevel] +
                                                            ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound2 +
                                                            matchingSoftware.name,nil)
                                end
                            else
                                showHelp
                            end
                        end
                    end
                end

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareDisableOption::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareDisableOption::ShowHelpExampleText1 +
                        "\t" + "#{ISM::Default::Option::SoftwareDisableOption::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
