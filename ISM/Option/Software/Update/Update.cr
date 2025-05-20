module ISM

    module Option

        class SoftwareUpdate < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareUpdate::ShortText,
                        ISM::Default::Option::SoftwareUpdate::LongText,
                        ISM::Default::Option::SoftwareUpdate::Description)
            end

            def start
                print ISM::Default::Option::SoftwareUpdate::UpdateTitle

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
