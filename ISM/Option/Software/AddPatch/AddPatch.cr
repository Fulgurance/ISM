module ISM

    module Option

        class Software

            class AddPatch < ISM::CommandLineOption

                module Default

                    ShortText = "-ap"
                    LongText = "addpatch"
                    Description = "Add a local patch for a specific software\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism software [softwarename-softwareversion] addpatch [patchpath]"
                    ShowHelpDescription = "Add a local patch for a specific software"
                    ShowHelpExampleText1 = "Need to be use like this:"
                    ShowHelpExampleText2 = "ism software [softwarename-softwareversion] addpatch [patchpath]"
                    NoMatchFound = "No match found with the database for "
                    NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                    Text1 = "Adding patch "
                    Text2 = " for the software "
                    NoFileFound1 = "The patch located at "
                    NoFileFound2 = " is not found for the software "

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

                        if matchingSoftware.name == ""
                            puts Default::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                            puts Default::NoMatchFoundAdvice
                        else
                            if ARGV[2] == @shortText || ARGV[2] == @longText
                                patchPath = ARGV[3]

                                if Ism.addPatch(patchPath,matchingSoftware.versionName)
                                    Ism.printProcessNotification(   Default::Text1 +
                                                                patchPath +
                                                                Default::Text2 +
                                                                matchingSoftware.name)
                                else
                                    Ism.printErrorNotification( Default::NoFileFound1 +
                                                            patchPath +
                                                            Default::NoFileFound2 +
                                                            matchingSoftware.name,nil)
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
