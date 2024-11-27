module ISM

    module Option

        class SoftwareDeletePatch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareDeletePatch::ShortText,
                        ISM::Default::Option::SoftwareDeletePatch::LongText,
                        ISM::Default::Option::SoftwareDeletePatch::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase, allowSearchByNameOnly: true)

                        if matchingSoftware.name == ""
                            puts ISM::Default::Option::SoftwareDeletePatch::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                            puts ISM::Default::Option::SoftwareDeletePatch::NoMatchFoundAdvice
                        else
                            if ARGV[2] == @shortText || ARGV[2] == @longText
                                patchName = ARGV[3]

                                if Ism.deletePatch(patchName,matchingSoftware.versionName)
                                    Ism.printProcessNotification(   ISM::Default::Option::SoftwareDeletePatch::Text1 +
                                                                patchName +
                                                                ISM::Default::Option::SoftwareDeletePatch::Text2 +
                                                                matchingSoftware.name)
                                else
                                    Ism.printErrorNotification( ISM::Default::Option::SoftwareDeletePatch::NoFileFound1 +
                                                            patchName +
                                                            ISM::Default::Option::SoftwareDeletePatch::NoFileFound2 +
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
                puts    ISM::Default::Option::SoftwareDeletePatch::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareDeletePatch::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareDeletePatch::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
