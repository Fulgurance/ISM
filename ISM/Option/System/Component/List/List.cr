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

                        Ism.components.each_with_index do |component, index|

                            entry <<-ENTRY
                            #{component.name}
                            ENTRY

                            puts entry

                        end
                    end

                end
            end

        end

    end

end
