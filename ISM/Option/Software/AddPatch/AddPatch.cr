module ISM

    module Option

        class SoftwareAddPatch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareAddPatch::ShortText,
                        ISM::Default::Option::SoftwareAddPatch::LongText,
                        ISM::Default::Option::SoftwareAddPatch::Description)
            end

            def start
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    matchingSoftware = Ism.getSoftwareInformation(ARGV[1].downcase, allowSearchByNameOnly: true)

                    if matchingSoftware.name == ""
                        puts ISM::Default::Option::SoftwareAddPatch::NoMatchFound + "#{ARGV[1].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareAddPatch::NoMatchFoundAdvice
                    else
                        if ARGV[2] == @shortText || ARGV[2] == @longText
                            patchPath = ARGV[3]

                            if Ism.addPatch(patchPath,matchingSoftware.versionName)
                                Ism.printProcessNotification(   ISM::Default::Option::SoftwareAddPatch::Text1 +
                                                            patchPath +
                                                            ISM::Default::Option::SoftwareAddPatch::Text2 +
                                                            matchingSoftware.name)
                            else
                                Ism.printErrorNotification( ISM::Default::Option::SoftwareAddPatch::NoFileFound1 +
                                                        patchPath +
                                                        ISM::Default::Option::SoftwareAddPatch::NoFileFound2 +
                                                        matchingSoftware.name,nil)
                            end
                        else
                            showHelp
                        end
                    end
                end

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareAddPatch::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareAddPatch::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareAddPatch::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
