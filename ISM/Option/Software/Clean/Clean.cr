module ISM

    module Option

        class SoftwareClean < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareClean::ShortText,
                        ISM::Default::Option::SoftwareClean::LongText,
                        ISM::Default::Option::SoftwareClean::Description)
            end

            def start
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
