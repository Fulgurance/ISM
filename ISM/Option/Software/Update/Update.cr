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
                Ism.showCalculationTitleMessage

                softwaresToUpdate = Ism.getSoftwaresToUpdate

                Ism.showCalculationDoneMessage
                Ism.showSoftwares(softwaresToUpdate)
                Ism.showUpdateQuestion(softwaresToUpdate.size)

                userAgreement = Ism.getUserAgreement

                if userAgreement
                    Ism.startUpdateProcess(softwaresToUpdate)
                end
            end

        end
        
    end

end
