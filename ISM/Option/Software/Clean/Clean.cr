module ISM

    module Option

        class SoftwareClean < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareClean::ShortText,
                        ISM::Default::Option::SoftwareClean::LongText,
                        ISM::Default::Option::SoftwareClean::Description)
            end

            def start
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
