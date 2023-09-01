module ISM

    module Option

        class SoftwareUpdate < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareUpdate::ShortText,
                        ISM::Default::Option::SoftwareUpdate::LongText,
                        ISM::Default::Option::SoftwareUpdate::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
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

                    if unneededSoftwares.size > 0
                        Ism.showCalculationDoneMessage
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
