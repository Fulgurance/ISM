module ISM

    module Option

        class Software

            class Clean < ISM::CommandLineOption

                module Default

                    ShortText = "-c"
                    LongText = "clean"
                    Description = "Clean the system by remove unneeded softwares"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
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

end
