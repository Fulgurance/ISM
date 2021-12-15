module ISM

    class CommandLine

        property options = ISM::Default::CommandLine::Options
        property settings = ISM::Default::CommandLine::Settings
        property softwares = ISM::Default::CommandLine::Softwares

        def initialize( options = ISM::Default::CommandLine::Options,
                        settings = ISM::Default::CommandLine::Settings,
                        softwares = ISM::Default::CommandLine::Softwares)
            @options = options
            @settings = settings
            @softwares = softwares
        end

        def start
            loadSoftwareDatabase
            checkEnteredArguments
        end

        def loadSoftwareDatabase
            if !Dir.exists?(ISM::Default::Path::SoftwaresDirectory)
                Dir.mkdir(ISM::Default::Path::SoftwaresDirectory)
            end
            
            softwareDirectories = Dir.entries(ISM::Default::Path::SoftwaresDirectory)
            softwareDirectories.shift
            softwareDirectories.shift

            softwareDirectories.each do |softwareDirectory|
                versionDirectories = Dir.entries(ISM::Default::Path::SoftwaresDirectory+softwareDirectory)
                versionDirectories.shift
                versionDirectories.shift

                versionDirectories.each do |versionDirectory|
                    softwareInformation = ISM::SoftwareInformation.new
                    softwareInformation.loadInformationFile(ISM::Default::Path::SoftwaresDirectory+"/"+softwareDirectory+"/"+versionDirectory+"/"+ISM::Default::Filename::Information)
                    @softwares.push(softwareInformation)
                end
            end
        end

        def checkEnteredArguments
            if ARGV.empty? || ARGV[0] == ISM::Default::Option::Help::ShortText || ARGV[0] == ISM::Default::Option::Help::LongText
                showHelp
            else
                matchingOption = false

                @options.each_with_index do |argument, index|
                    if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                        matchingOption = true
                        @options[index].start
                        break
                    end
                end

                if !matchingOption
                    showErrorUnknowArgument
                end
            end
        end

        def showHelp
            puts ISM::Default::CommandLine::Title
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end
        end

        def showErrorUnknowArgument
            puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
            puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
        end

    end

end
