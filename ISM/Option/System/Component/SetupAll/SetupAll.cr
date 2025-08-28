module ISM

    module Option

        class ComponentSetupAll < ISM::CommandLineOption

            module Default

                ShortText = "-sa"
                LongText = "setupall"
                Description = "Setup all components with their default values. Overwrite existing configuration."
                Text = "Setting up all components with default values. The base is ready."

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                Ism.printProcessNotification(Default::Text)

                Ism.components.each do |component|
                    component.writeConfiguration(component.settingsFilePath)
                end
            end

        end

    end

end
