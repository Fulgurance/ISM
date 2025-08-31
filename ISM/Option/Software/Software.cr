module ISM

    module Option

        class Software < ISM::CommandLineOption

            module Default

                ShortText = "-so"
                LongText = "software"
                Description = "Install, configure and remove softwares"
                Options = [ Option::Software::Search.new,
                            Option::Software::Update.new,
                            Option::Software::Install.new,
                            Option::Software::Uninstall.new,
                            Option::Software::Clean.new,
                            Option::Software::SelectDependency.new,
                            Option::Software::EnableOption.new,
                            Option::Software::DisableOption.new,
                            Option::Software::AddPatch.new,
                            Option::Software::DeletePatch.new]

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description,
                        Default::Options)
            end

            def start
                if ARGV.size == 1
                    showHelp
                else
                    matchingOption = false

                    @options.each_with_index do |argument, index|
                        if ARGV[1] == argument.shortText || ARGV[1] == argument.longText
                            matchingOption = true
                            @options[index].start
                            break
                        end
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::EnableOption::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::EnableOption::Default::LongText
                        matchingOption = true
                        @options[-4].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::DisableOption::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::DisableOption::Default::LongText
                        matchingOption = true
                        @options[-3].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::SelectDependency::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::SelectDependency::Default::LongText
                        matchingOption = true
                        @options[-5].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::AddPatch::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::AddPatch::Default::LongText
                        matchingOption = true
                        @options[-2].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::DeletePatch::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::Software::DeletePatch::Default::LongText
                        matchingOption = true
                        @options[-1].start
                    end

                    if !matchingOption
                        puts "#{CommandLine::Default::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[1].colorize(:white)}"
                        puts    "#{CommandLine::Default::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{CommandLine::Default::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{CommandLine::Default::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
