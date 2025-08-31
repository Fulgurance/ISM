module ISM

    module Option

        class Software

            class Update < ISM::CommandLineOption

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

                        Ism.requestedSoftwares.clear

                        #Clean the system and remove unneeded softwares
                        Ism.showCalculationTitleMessage

                        unneededSoftwares = Ism.getUnneededSoftwares

                        Ism.showCalculationDoneMessage

                        if unneededSoftwares.size > 0
                            Ism.showSoftwares(unneededSoftwares, :uninstallation)
                            Ism.showUninstallationQuestion(unneededSoftwares.size)

                            userAgreement = Ism.getUserAgreement

                            if userAgreement
                                Ism.startUninstallationProcess(unneededSoftwares)
                            end
                        else
                            Ism.showNoCleaningRequiredMessage
                        end
                    end
                end

            end

        end
        
    end

end
