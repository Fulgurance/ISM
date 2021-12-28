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
                if ARGV.size == 2 || ARGV.size == 3
                    showHelp
                else
                    wrongMatch = false
                    badEntry = ""
                    matchingSoftware = ISM::SoftwareInformation.new

                    Ism.softwares.each_with_index do |software, index|
                        if ARGV[1] == software.name || ARGV[1] == software.name.downcase
                            matchingSoftware = software.versions.last
                        else
                            software.versions.each do |version|
                                if ARGV[1] == version.versionName || ARGV[1] == version.versionName.downcase
                                    matchingSoftware = version
                                else
                                    wrongMatch = true
                                    badEntry = ARGV[1]
                                    break
                                end
                            end
                        end
                        if wrongMatch
                            break
                        end
                    end

                    if wrongMatch
                        puts ISM::Default::Option::SoftwareEnableOption::NoMatchFound + "#{badEntry.colorize(:green)}"
                        puts ISM::Default::Option::SoftwareEnableOption::NoMatchFoundAdvice
                    else
                        if ARGV[2] == @shortText || ARGV[2] == @longText
                            match = false
                            matchingOption = ISM::SoftwareOption.new

                            matchingSoftware.options.each_with_index do |option, index|
                                if ARGV[3] == option.name || ARGV[3] == option.name.downcase
                                    matchingSoftware.options[index].active = true
                                    matchingOption = option
                                    match = true
                                end
                            end

                            if match
                                if !Dir.exists?(ISM::Default::Path::SettingsSoftwaresDirectory +
                                                matchingSoftware.name + "/" +
                                                matchingSoftware.version)
                                    Dir.mkdir_p(ISM::Default::Path::SettingsSoftwaresDirectory +
                                                matchingSoftware.name + "/" +
                                                matchingSoftware.version)
                                end
                                matchingSoftware.writeInformationFile(  ISM::Default::Path::SettingsSoftwaresDirectory +
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
                                        ARGV[3] +
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
