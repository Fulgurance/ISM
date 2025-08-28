module ISM

    module Option

        class ComponentSetup < ISM::CommandLineOption

            module Default

                ShortText = "-s"
                LongText = "setup"
                Description = "Setup a single component with default values. Overwrite existing configuration."
                Text1 = "Setting up "
                Text2 = ". The component is ready."

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
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

                    Ism.printProcessNotification(   Default::Text1 +
                                                    "#{("@"+matchingComponent.port).colorize(:red)}:#{matchingComponent.name.colorize(:green)}" +
                                                    Default::Text2)
                end

            end

        end

    end

end
