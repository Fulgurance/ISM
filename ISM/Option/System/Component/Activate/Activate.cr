module ISM

    module Option

        class System

            class Component

                class Activate < CommandLine::Option

                    module Default

                        ShortText = "-a"
                        LongText = "activate"
                        Description = "Activate a specific system component\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism system component [componentname] activate [optionname]"
                        ShowHelpDescription = "Activate a specific system component"
                        ShowHelpExampleText1 = "Need to be use like this:"
                        ShowHelpExampleText2 = "ism system component [componentname] activate [optionname]"
                        NoMatchFound = "No match found with the database for "
                        NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                        SetText1 = "Enabling the option "
                        SetText2 = " for the component "
                        OptionNoMatchFound1 = "No matching option named "
                        OptionNoMatchFound2 = " found for the component "

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

                            if !matchingSoftware.isValid
                                puts Default::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                                puts Default::NoMatchFoundAdvice
                            else
                                if ARGV[2] == @shortText || ARGV[2] == @longText
                                    match = false
                                    matchingOption = ISM::Software::Option.new

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
                                        Ism.printProcessNotification(   Default::SetText1 +
                                                                    "#{matchingOption.name.colorize(:green)}" +
                                                                    Default::SetText2 +
                                                                    matchingSoftwareText)
                                    else
                                        Ism.printErrorNotification( Default::OptionNoMatchFound1 +
                                                                "#{ARGV[3].colorize(:green)}" +
                                                                Default::OptionNoMatchFound2 +
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
        
    end

end
