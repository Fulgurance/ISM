module ISM

    module Option

        class SoftwareInstall < ISM::CommandLineOption

            module Default

                ShortText = "-i"
                LongText = "install"
                Description = "Install specific(s) software(s)"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
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

                        Ism.showNoMatchFoundMessage(wrongArguments)
                        Ism.exitProgram
                    end

                    #No available version found
                    if Ism.requestedSoftwares.any? {|software| software.version == ""}
                        wrongArguments = Array(String).new

                        Ism.requestedSoftwares.each do |software|
                            if software.version == ""
                                wrongArguments.push(software.versionName)
                            end
                        end

                        Ism.showNoVersionAvailableMessage(wrongArguments)
                        Ism.exitProgram
                    end

                    Ism.showCalculationTitleMessage

                    neededSoftwares = Ism.getNeededSoftwares

                    Ism.showCalculationDoneMessage
                    Ism.showSoftwares(neededSoftwares)
                    Ism.showInstallationQuestion(neededSoftwares.size)

                    userAgreement = Ism.getUserAgreement

                    if userAgreement
                        Ism.startInstallationProcess(neededSoftwares)
                    end
                end
            end

        end

    end

end
