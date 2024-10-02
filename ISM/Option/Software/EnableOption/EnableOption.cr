module ISM

    module Option

        class SoftwareEnableOption < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareEnableOption::ShortText,
                        ISM::Default::Option::SoftwareEnableOption::LongText,
                        ISM::Default::Option::SoftwareEnableOption::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase)

                        if !matchingSoftware.isValid
                            puts ISM::Default::Option::SoftwareEnableOption::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                            puts ISM::Default::Option::SoftwareEnableOption::NoMatchFoundAdvice
                        else
                            if ARGV[2] == @shortText || ARGV[2] == @longText
                                match = false
                                matchingOption = ISM::SoftwareOption.new

                                matchingSoftware.options.each do |option|
                                    if ARGV[3] == option.name || ARGV[3] == option.name.downcase
                                        matchingSoftware.enableOption(option.name)
                                        matchingOption = option
                                        match = true
                                    end
                                end

                                matchingSoftwareText = "#{("@"+matchingSoftware.port).colorize(:red)}:#{matchingSoftware.name.colorize(:green)}"

                                if match
                                    matchingSoftware.writeConfiguration(matchingSoftware.settingsFilePath)
                                    Ism.printProcessNotification(   ISM::Default::Option::SoftwareEnableOption::SetText1 +
                                                                "#{matchingOption.name.colorize(:green)}" +
                                                                ISM::Default::Option::SoftwareEnableOption::SetText2 +
                                                                matchingSoftwareText)
                                else
                                    Ism.printErrorNotification( ISM::Default::Option::SoftwareEnableOption::OptionNoMatchFound1 +
                                                            "#{ARGV[3].colorize(:green)}" +
                                                            ISM::Default::Option::SoftwareEnableOption::OptionNoMatchFound2 +
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
                puts    ISM::Default::Option::SoftwareEnableOption::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareEnableOption::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareEnableOption::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
