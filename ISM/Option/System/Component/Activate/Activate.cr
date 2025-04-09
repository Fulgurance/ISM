module ISM

    module Option

        class ComponentActivate < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::ComponentActivate::ShortText,
                        ISM::Default::Option::ComponentActivate::LongText,
                        ISM::Default::Option::ComponentActivate::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase, allowSearchByNameOnly: true)

                    if !matchingSoftware.isValid
                        puts ISM::Default::Option::ComponentActivate::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                        puts ISM::Default::Option::ComponentActivate::NoMatchFoundAdvice
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
                                Ism.printProcessNotification(   ISM::Default::Option::ComponentActivate::SetText1 +
                                                            "#{matchingOption.name.colorize(:green)}" +
                                                            ISM::Default::Option::ComponentActivate::SetText2 +
                                                            matchingSoftwareText)
                            else
                                Ism.printErrorNotification( ISM::Default::Option::ComponentActivate::OptionNoMatchFound1 +
                                                        "#{ARGV[3].colorize(:green)}" +
                                                        ISM::Default::Option::ComponentActivate::OptionNoMatchFound2 +
                                                        matchingSoftwareText,nil)
                            end
                        else
                            showHelp
                        end
                    end
                end

            end

            def showHelp
                puts    ISM::Default::Option::ComponentActivate::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::ComponentActivate::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::ComponentActivate::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
