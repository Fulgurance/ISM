module ISM

    module Option

        class ComponentList < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::ComponentList::ShortText,
                        ISM::Default::Option::ComponentList::LongText,
                        ISM::Default::Option::ComponentList::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    if Ism.components.empty?
                        puts ISM::Default::Option::ComponentList::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                        puts ISM::Default::Option::ComponentList::NoMatchFoundAdvice
                    else
                        puts "\n"
                        puts "#{ISM::Default::Option::ComponentList::Title.colorize(:green)}"
                        puts

                        Ism.components.each_with_index do |component, index|
                            status = (Ism.softwareIsInstalled(component) ? ISM::Default::Option::ComponentList::EnabledText.colorize(:green) : ISM::Default::Option::ComponentList::DisabledText.colorize(:red))
                            enabledOptions = String.new

                            component.options.each_with_index do |option, index|
                                if option.enabled

                                    enabledOptions += "#{index > 0 ? " " : ""}#{option.name}"

                                end
                            end

                            #For each component, show if it is enabled and there is anything set
                            entry = <<-ENTRY
                            [#{status}] #{component.name} [ #{enabledOptions} ]
                            ENTRY

                            puts entry

                        end
                    end

                end
            end

        end

    end

end
