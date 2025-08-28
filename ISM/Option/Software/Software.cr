module ISM

    module Option

        class Software < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Software::ShortText,
                        ISM::Default::Option::Software::LongText,
                        ISM::Default::Option::Software::Description,
                        ISM::Default::Option::Software::Options)
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

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareEnableOption::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareEnableOption::LongText
                        matchingOption = true
                        @options[-4].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareDisableOption::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareDisableOption::LongText
                        matchingOption = true
                        @options[-3].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareSelectDependency::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareSelectDependency::LongText
                        matchingOption = true
                        @options[-5].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareAddPatch::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareAddPatch::LongText
                        matchingOption = true
                        @options[-2].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareDeletePatch::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == ISM::Default::Option::SoftwareDeletePatch::LongText
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
