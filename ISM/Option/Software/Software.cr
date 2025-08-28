module ISM

    module Option

        class Software < ISM::CommandLineOption

            module Default

                ShortText = "-so"
                LongText = "software"
                Description = "Install, configure and remove softwares"
                Options = [ ISM::Option::SoftwareSearch.new,
                            ISM::Option::SoftwareUpdate.new,
                            ISM::Option::SoftwareInstall.new,
                            ISM::Option::SoftwareUninstall.new,
                            ISM::Option::SoftwareClean.new,
                            ISM::Option::SoftwareSelectDependency.new,
                            ISM::Option::SoftwareEnableOption.new,
                            ISM::Option::SoftwareDisableOption.new,
                            ISM::Option::SoftwareAddPatch.new,
                            ISM::Option::SoftwareDeletePatch.new]

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

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareEnableOption::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareEnableOption::Default::LongText
                        matchingOption = true
                        @options[-4].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareDisableOption::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareDisableOption::Default::LongText
                        matchingOption = true
                        @options[-3].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareSelectDependency::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareSelectDependency::Default::LongText
                        matchingOption = true
                        @options[-5].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareAddPatch::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareAddPatch::Default::LongText
                        matchingOption = true
                        @options[-2].start
                    end

                    if  !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareDeletePatch::Default::ShortText ||
                        !matchingOption && ARGV.size > 2 && ARGV[2] == Option::SoftwareDeletePatch::Default::LongText
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
