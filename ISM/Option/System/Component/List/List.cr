module ISM

    module Option

        class System

            class Component

                class List < ISM::CommandLineOption

                    module Default

                        ShortText = "-l"
                        LongText = "list"
                        Description = "List all available components"
                        NoMatchFound = "No match found with the database for "
                        NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                        Title = "Available system components:"
                        EnabledText = "Enabled"
                        DisabledText = "Disabled"

                    end

                    def initialize
                        super(  Default::ShortText,
                                Default::LongText,
                                Default::Description)
                    end

                    def start
                        if Ism.components.empty?
                            puts Default::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                            puts Default::NoMatchFoundAdvice
                        else
                            puts "\n"
                            puts "#{Default::Title.colorize(:green)}"
                            puts

                            Ism.components.each_with_index do |component, index|
                                status = (Ism.softwareIsInstalled(component) ? Default::EnabledText.colorize(:green) : Default::DisabledText.colorize(:red))
                                enabledOptions = String.new

                                component.options.each_with_index do |option, index|
                                    if option.active

                                        enabledOptions += "#{index > 0 ? " " : ""}#{option.name}#{index < (component.options.size-1) ? "," : ""}"

                                    end
                                end

                                component.selectedDependencies.each_with_index do |dependency, index|
                                    information = Ism.getSoftwareInformation(dependency)
                                    enabledOptions += "#{index > 0 ? " " : ""}#{information.name}"
                                end

                                if enabledOptions.empty?
                                    enabledOptions = "none"
                                end

                                #For each component, show if it is enabled and there is anything set
                                entry = <<-ENTRY
                                #{component.name}: #{enabledOptions.colorize(:green)}
                                ENTRY

                                puts entry

                            end
                        end

                    end

                end

            end

        end

    end

end
