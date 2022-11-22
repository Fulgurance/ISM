module ISM

    module Option

        class SoftwareEnableOption < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareEnableOption::ShortText,
                        ISM::Default::Option::SoftwareEnableOption::LongText,
                        ISM::Default::Option::SoftwareEnableOption::Description,
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
                                    badEntry = ARGV[1+Ism.debugLevel]
                                end
                            end
                        end
                    end

                    if !matching
                        puts ISM::Default::Option::SoftwareEnableOption::NoMatchFound + "#{badEntry.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareEnableOption::NoMatchFoundAdvice
                    else
                        if ARGV[2+Ism.debugLevel] == @shortText || ARGV[2+Ism.debugLevel] == @longText
                            match = false
                            matchingOption = ISM::SoftwareOption.new

                            matchingSoftware.options.each_with_index do |option, index|
                                if ARGV[3+Ism.debugLevel] == option.name || ARGV[3+Ism.debugLevel] == option.name.downcase
                                    matchingSoftware.options[index].active = true
                                    matchingOption = option
                                    match = true
                                end
                            end

                            if match
                                if !Dir.exists?(ISM::Default::Path::SettingsSoftwaresDirectory +
                                                matchingSoftware.port + "/" +
                                                matchingSoftware.name + "/" +
                                                matchingSoftware.version)
                                    Dir.mkdir_p(ISM::Default::Path::SettingsSoftwaresDirectory +
                                                matchingSoftware.port + "/" +
                                                matchingSoftware.name + "/" +
                                                matchingSoftware.version)
                                end
                                matchingSoftware.writeInformationFile(  ISM::Default::Path::SettingsSoftwaresDirectory +
                                                                        matchingSoftware.port + "/" +
                                                                        matchingSoftware.name + "/" +
                                                                        matchingSoftware.version + "/" +
                                                                        ISM::Default::Filename::SoftwareSettings)
                                puts    "#{"* ".colorize(:green)}" +
                                        ISM::Default::Option::SoftwareEnableOption::SetText1 +
                                        matchingOption.name +
                                        ISM::Default::Option::SoftwareEnableOption::SetText2 +
                                        matchingSoftware.name
                            else
                                puts    ISM::Default::Option::SoftwareEnableOption::OptionNoMatchFound1 +
                                        ARGV[3+Ism.debugLevel] +
                                        ISM::Default::Option::SoftwareEnableOption::OptionNoMatchFound2 +
                                        matchingSoftware.name
                            end
                        else
                            showHelp
                        end
                    end    

                end

            end

            def showHelp
                puts    ISM::Default::Option::SoftwareEnableOption::ShowHelpDescription +
                        "\n\n\t" + ISM::Default::Option::SoftwareEnableOption::ShowHelpExampleText1 +
                        "\n\t" + "#{ISM::Default::Option::SoftwareEnableOption::ShowHelpExampleText2.colorize(:green)}"
            end

        end
        
    end

end
