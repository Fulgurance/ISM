module ISM

    module Option

        class ComponentSetup < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::ComponentSetup::ShortText,
                        ISM::Default::Option::ComponentSetup::LongText,
                        ISM::Default::Option::ComponentSetup::Description)
            end

            def start
                if ARGV.size == 3
                    showHelp
                else
                    userRequest = ARGV[3]
                    matchingComponent = ISM::SoftwareInformation.new

                    Ism.components.each do |component|
                        if component.fullName.downcase == userRequest.downcase || component.name.downcase == userRequest.downcase
                            matchingComponent = component
                            break
                        end
                    end

                    #No match found
                    if !matchingComponent.isValid
                        Ism.showNoMatchFoundMessage([userRequest])
                        Ism.exitProgram
                    end

                    matchingComponent.writeConfiguration(matchingComponent.settingsFilePath)

                    Ism.printProcessNotification(   ISM::Default::Option::ComponentSetup::Text1 +
                                                    "#{("@"+matchingComponent.port).colorize(:red)}:#{matchingComponent.name.colorize(:green)}" +
                                                    ISM::Default::Option::ComponentSetup::Text2)
                end

            end

        end

    end

end
