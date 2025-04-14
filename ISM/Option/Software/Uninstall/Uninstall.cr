module ISM

    module Option

        class SoftwareUninstall < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareUninstall::ShortText,
                        ISM::Default::Option::SoftwareUninstall::LongText,
                        ISM::Default::Option::SoftwareUninstall::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    userRequest = ARGV[2..-1].uniq
                    Ism.requestedSoftwares = Ism.getRequestedSoftwares(userRequest, allowSearchByNameOnly: true)

                    #No match found
                    if userRequest.size != Ism.requestedSoftwares.size
                        wrongArguments = Array(String).new

                        userRequest.each do |request|
                            exist = false

                            Ism.requestedSoftwares.each do |software|
                                if request.downcase == software.fullName.downcase || request.downcase == software.fullVersionName.downcase
                                    exist = true
                                    break
                                end
                            end

                            if !exist
                                wrongArguments.push(request)
                            end
                        end

                        ISM::Core::Notification.noMatchFoundMessage(wrongArguments)

                        ISM::Core.exitProgram
                    end

                    #No available version found
                    if Ism.requestedSoftwares.any? {|software| software.version == ""}
                        wrongArguments = Array(String).new

                        Ism.requestedSoftwares.each do |software|
                            if software.version == ""
                                wrongArguments.push(software.versionName)
                            end
                        end

                        ISM::Core::Notification.noVersionAvailableMessage(wrongArguments)

                        ISM::Core.exitProgram
                    end

                    #Software not installed yet
                    if Ism.requestedSoftwares.any? {|software| !Ism.softwareIsInstalled(software)}
                        wrongArguments = Array(String).new

                        Ism.requestedSoftwares.each do |software|
                            if !Ism.softwareIsInstalled(software)
                                wrongArguments.push(software.name)
                            end
                        end

                        ISM::Core::Notification.softwareNotInstalledMessage(wrongArguments)

                        ISM::Core.exitProgram
                    end

                    ISM::Core::Notification.calculationTitleMessage

                    unneededSoftwares = Ism.getUnneededSoftwares

                    ISM::Core::Notification.calculationDoneMessage
                    ISM::Core::Notification.softwares(unneededSoftwares, :uninstallation)
                    ISM::Core::Notification.uninstallationQuestion(unneededSoftwares.size)

                    userAgreement = Ism.getUserAgreement

                    if userAgreement
                        Ism.startUninstallationProcess(unneededSoftwares)
                    end
                end
            end

        end

    end

end
