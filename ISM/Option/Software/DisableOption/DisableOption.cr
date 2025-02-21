module ISM

    module Option

        class SoftwareDisableOption < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareDisableOption::ShortText,
                        ISM::Default::Option::SoftwareDisableOption::LongText,
                        ISM::Default::Option::SoftwareDisableOption::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase, allowSearchByNameOnly: true)

                    if !matchingSoftware.isValid
                        puts ISM::Default::Option::SoftwareDisableOption::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareDisableOption::NoMatchFoundAdvice
                    else
                        if ARGV[2] == @shortText || ARGV[2] == @longText
                            match = false
                            matchingOption = ISM::SoftwareOption.new

                            matchingSoftware.options.each do |option|
                                if ARGV[3] == option.name || ARGV[3] == option.name.downcase
                                    matchingSoftware.disableOption(option.name)
                                    matchingOption = option
                                    match = true
                                end
                            end

                            matchingSoftwareText = "#{("@"+matchingSoftware.port).colorize(:red)}:#{matchingSoftware.name.colorize(:green)}"

                            if match
                                matchingSoftware.writeConfiguration(matchingSoftware.settingsFilePath)
                                Ism.printProcessNotification(   ISM::Default::Option::SoftwareDisableOption::SetText1 +
                                                            "#{matchingOption.name.colorize(:green)}" +
                                                            ISM::Default::Option::SoftwareDisableOption::SetText2 +
                                                            matchingSoftwareText)
                            else
                                Ism.printErrorNotification( ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound1 +
                                                        "#{ARGV[3].colorize(:green)}" +
                                                        ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound2 +
                                                        matchingSoftwareText,nil)
                            end
                        else
                            showHelp
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
