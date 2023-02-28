module ISM

    module Option

        class SoftwareDisableOption < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareDisableOption::ShortText,
                        ISM::Default::Option::SoftwareDisableOption::LongText,
                        ISM::Default::Option::SoftwareDisableOption::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel || ARGV.size == 3+Ism.debugLevel
                    showHelp
                else
                    matching = false
                    badEntry = ""
                    matchingSoftware = ISM::SoftwareInformation.new

                    Ism.softwares.each_with_index do |software, index|
                        if ARGV[1+Ism.debugLevel] == software.name || ARGV[1+Ism.debugLevel] == software.name.downcase
                            matchingSoftware = software.versions.last
                            matching = true
                            break
                        else
                            software.versions.each do |version|
                                if ARGV[1+Ism.debugLevel] == version.versionName || ARGV[1+Ism.debugLevel] == version.versionName.downcase
                                    matchingSoftware = version
                                    matching = true
                                    break
                                else
                                    badEntry = ARGV[1]
                                end
                            end
                        end
                    end

                    if !matching
                        puts ISM::Default::Option::SoftwareDisableOption::NoMatchFound + "#{badEntry.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareDisableOption::NoMatchFoundAdvice
                    else
                        if ARGV[2+Ism.debugLevel] == @shortText || ARGV[2+Ism.debugLevel] == @longText
                            match = false
                            matchingOption = ISM::SoftwareOption.new

                            matchingSoftware.options.each do |option|
                                if ARGV[3+Ism.debugLevel] == option.name || ARGV[3+Ism.debugLevel] == option.name.downcase
                                    matchingSoftware.disableOption(option.name)
                                    matchingOption = option
                                    match = true
                                end
                            end

                            if match
                                matchingSoftware.writeInformationFile(  Ism.settings.rootPath +
                                                                        ISM::Default::Path::SettingsSoftwaresDirectory +
                                                                        matchingSoftware.port + "/" +
                                                                        matchingSoftware.name + "/" +
                                                                        matchingSoftware.version + "/" +
                                                                        ISM::Default::Filename::SoftwareSettings)
                                puts    "#{"* ".colorize(:green)}" +
                                        ISM::Default::Option::SoftwareDisableOption::SetText1 +
                                        matchingOption.name +
                                        ISM::Default::Option::SoftwareDisableOption::SetText2 +
                                        matchingSoftware.name
                            else
                                puts    ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound1 +
                                        ARGV[3+Ism.debugLevel] +
                                        ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound2 +
                                        matchingSoftware.name
                            end
                        else
                            showHelp
                        end
                    end    

                end

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareDisableOption::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareDisableOption::ShowHelpExampleText1 +
                        "\t" + "#{ISM::Default::Option::SoftwareDisableOption::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
