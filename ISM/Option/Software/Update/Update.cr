module ISM

    module Option

        class Software

            class Update < CommandLine::Option

                module Default

                    ShortText = "-u"
                    LongText = "update"
                    Description = "Performs a software update"
                    UpdateTitle = "Checking avaible updates: "

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    print Default::UpdateTitle

                    Ism.requestedSoftwares = Ism.getSoftwaresToUpdate

                    #No update
                    if Ism.requestedSoftwares.empty?
                        Ism.showNoUpdateMessage
                        Ism.exitProgram
                    end

                    Ism.showCalculationTitleMessage

                    neededSoftwares = Ism.getNeededSoftwares

                    Ism.showCalculationDoneMessage
                    Ism.showSoftwares(neededSoftwares)
                    Ism.showUpdateQuestion(neededSoftwares.size)

                    userAgreement = Ism.getUserAgreement

                    if userAgreement
                        Ism.startInstallationProcess(neededSoftwares)
                    end
                end

            end

        end
        
    end

end
