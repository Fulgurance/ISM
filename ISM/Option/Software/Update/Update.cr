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
                    ISM::Core::Notification.noUpdateMessage

                    ISM::Core.exitProgram
                end

                ISM::Core::Notification.calculationTitleMessage

                neededSoftwares = Ism.getNeededSoftwares

                ISM::Core::Notification.calculationDoneMessage
                ISM::Core::Notification.softwares(neededSoftwares)
                ISM::Core::Notification.updateQuestion(neededSoftwares.size)

                userAgreement = Ism.getUserAgreement

                if userAgreement
                    Ism.startInstallationProcess(neededSoftwares)

                    Ism.requestedSoftwares.clear

                    #Clean the system and remove unneeded softwares
                    ISM::Core::Notification.calculationTitleMessage

                    unneededSoftwares = Ism.getUnneededSoftwares

                    ISM::Core::Notification.calculationDoneMessage

                    if unneededSoftwares.size > 0
                        ISM::Core::Notification.softwares(unneededSoftwares, :uninstallation)
                        ISM::Core::Notification.uninstallationQuestion(unneededSoftwares.size)

                        userAgreement = Ism.getUserAgreement

                        if userAgreement
                            Ism.startUninstallationProcess(unneededSoftwares)
                        end
                    else
                        ISM::Core::Notification.noCleaningRequiredMessage
                    end
                end
            end

        end
        
    end

end
