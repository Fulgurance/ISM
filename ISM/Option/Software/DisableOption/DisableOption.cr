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
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    matching = false
                    badEntry = ""
                    matchingSoftware = ISM::SoftwareInformation.new

                    Ism.softwares.each_with_index do |software, index|
                        if ARGV[1] == software.name || ARGV[1] == software.name.downcase
                            matchingSoftware = software.versions.last
                            matching = true
                            break
                        else
                            software.versions.each do |version|
                                if ARGV[1] == version.versionName || ARGV[1] == version.versionName.downcase
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
                        if ARGV[2] == @shortText || ARGV[2] == @longText
                            match = false
                            matchingOption = ISM::SoftwareOption.new

                            matchingSoftware.options.each_with_index do |option, index|
                                if ARGV[3] == option.name || ARGV[3] == option.name.downcase
                                    matchingSoftware.options[index].active = false
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
                                        ISM::Default::Option::SoftwareDisableOption::SetText1 +
                                        matchingOption.name +
                                        ISM::Default::Option::SoftwareDisableOption::SetText2 +
                                        matchingSoftware.name
                            else
                                puts    ISM::Default::Option::SoftwareDisableOption::OptionNoMatchFound1 +
                                        ARGV[3] +
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
