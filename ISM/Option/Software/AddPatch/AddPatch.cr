module ISM

    module Option

        class SoftwareAddPatch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareAddPatch::ShortText,
                        ISM::Default::Option::SoftwareAddPatch::LongText,
                        ISM::Default::Option::SoftwareAddPatch::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel || ARGV.size == 3+Ism.debugLevel
                    showHelp
                else
                    if !Ism.ranAsSuperUser && Ism.secureModeEnabled
                        Ism.printNeedSuperUserAccessNotification
                    else
                        matchingSoftware = Ism.getSoftwareInformation(ARGV[1+Ism.debugLevel].downcase)

                        if matchingSoftware.name == ""
                            puts ISM::Default::Option::SoftwareAddPatch::NoMatchFound + "#{ARGV[1+Ism.debugLevel].colorize(:green)}"
                            puts ISM::Default::Option::SoftwareAddPatch::NoMatchFoundAdvice
                        else
                            if ARGV[2+Ism.debugLevel] == @shortText || ARGV[2+Ism.debugLevel] == @longText
                                patchPath = ARGV[3+Ism.debugLevel]

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

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareAddPatch::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareAddPatch::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareAddPatch::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
