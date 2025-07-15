module ISM

    module Option

        class ComponentSetupAll < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::ComponentSetupAll::ShortText,
                        ISM::Default::Option::ComponentSetupAll::LongText,
                        ISM::Default::Option::ComponentSetupAll::Description)
            end

            def start
                Ism.printProcessNotification(ISM::Default::Option::ComponentSetupAll::Text)

                Ism.components.each do |component|
                    component.writeConfiguration(component.settingsFilePath)
                end
            end

        end

    end

end
