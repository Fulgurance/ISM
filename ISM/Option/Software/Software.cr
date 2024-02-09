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
                if ARGV.size == 1+Ism.debugLevel
                    showHelp
                else
                    matchingOption = false

                    @options.each_with_index do |argument, index|
                        if ARGV[1+Ism.debugLevel] == argument.shortText || ARGV[1+Ism.debugLevel] == argument.longText
                            matchingOption = true
                            @options[index].start
                            break
                        end
                    end

                    if  !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareEnableOption::ShortText ||
                        !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareEnableOption::LongText
                        matchingOption = true
                        @options[1].start
                    end

                    if  !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareDisableOption::ShortText ||
                        !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareDisableOption::LongText
                        matchingOption = true
                        @options[0].start
                    end

                    if  !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareAddPatch::ShortText ||
                        !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareAddPatch::LongText
                        matchingOption = true
                        @options[0].start
                    end

                    if  !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareDeletePatch::ShortText ||
                        !matchingOption && ARGV.size > 2+Ism.debugLevel && ARGV[2+Ism.debugLevel] == ISM::Default::Option::SoftwareDeletePatch::LongText
                        matchingOption = true
                        @options[0].start
                    end

                    if !matchingOption
                        puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[1+Ism.debugLevel].colorize(:white)}"
                        puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                                "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                                "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
                    end
                end
            end

        end
        
    end

end
