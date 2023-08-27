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
                end

                #ADD CLEANING PROCESS FOR OLD VERSION REMOVAL

            end

        end
        
    end

end
