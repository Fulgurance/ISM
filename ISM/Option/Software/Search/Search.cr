module ISM

    module Option

        class SoftwareSearch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareSearch::ShortText,
                        ISM::Default::Option::SoftwareSearch::LongText,
                        ISM::Default::Option::SoftwareSearch::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    matchingSoftwaresArray = Array(ISM::AvailableSoftware).new

                    Ism.softwares.each do |software|
                        if software.name.includes?(ARGV[2+Ism.debugLevel]) || software.name.downcase.includes?(ARGV[2+Ism.debugLevel])
                            matchingSoftwaresArray << software
                        end
                    end

                    if matchingSoftwaresArray.empty?
                        puts ISM::Default::Option::SoftwareSearch::NoMatchFound + "#{ARGV[2+Ism.debugLevel].colorize(:green)}"
                        puts ISM::Default::Option::SoftwareSearch::NoMatchFoundAdvice
                    else
                        puts "\n"

                        matchingSoftwaresArray.each_with_index do |software, index|
                            puts    ISM::Default::Option::SoftwareSearch::PortField +
                                        "#{software.greatestVersion.port.colorize(:green)}"

                            puts    ISM::Default::Option::SoftwareSearch::NameField +
                                        "#{software.name.colorize(:green)}"

                            puts    ISM::Default::Option::SoftwareSearch::DescriptionField +
                                        "#{software.greatestVersion.description.colorize(:green)}"

                            architecturesText = ""
                            software.greatestVersion.architectures.each_with_index do |architecture, index|
                                architecturesText += "#{architecture.colorize(:green)}"
                                if index+1 < software.greatestVersion.architectures.size
                                    architecturesText += " | "
                                end
                            end
                            if architecturesText.empty?
                                architecturesText = ISM::Default::Option::SoftwareSearch::None
                            end
                            puts    ISM::Default::Option::SoftwareSearch::AvailablesArchitecturesField +
                                        "#{architecturesText.colorize(:green)}"

                            puts    ISM::Default::Option::SoftwareSearch::WebsiteField +
                                        "#{software.greatestVersion.website.colorize(:green)}"

                            versionsText = ""
                            software.versions.each_with_index do |version, index|
                                versionsText += "#{version.version.colorize(:green)}"
                                if index+1 < software.versions.size
                                        versionsText += " | "
                                end
                            end
                            puts    ISM::Default::Option::SoftwareSearch::AvailablesVersionsField +
                                        "#{versionsText}"

                            installedVersionText = ""
                            Ism.installedSoftwares.each_with_index do |installed, index|
                                if software.name == installed.name
                                    installedVersionText += "#{"\n\t| ".colorize(:green)}"
                                    installedVersionText += "#{installed.version.colorize(Colorize::ColorRGB.new(255,100,100))}"

                                    installedVersionText += " { "

                                    installed.options.each do |option|

                                        if option.active
                                            installedVersionText += "#{option.name.colorize(:red)}"
                                        else
                                            installedVersionText += "#{option.name.colorize(:blue)}"
                                        end

                                        installedVersionText += " "
                                    end

                                    installedVersionText += "}"

                                end

                            end

                            if installedVersionText.empty?
                                installedVersionText = "#{ISM::Default::Option::SoftwareSearch::None.colorize(:green)}}"
                            end

                            puts    ISM::Default::Option::SoftwareSearch::InstalledVersionField +
                                        "#{installedVersionText.colorize(:green)}"

                            uniqueOptionsText = String.new

                            software.greatestVersion.options.each do |option|

                                software.greatestVersion.uniqueOptions.each do |uniqueOptionGroup|

                                    if !uniqueOptionGroup.includes?(option.name)
                                        puts "[#{option.active ? "*".colorize(:green) : " "}] #{option.name.colorize(:green)}: #{option.description}"
                                    end

                                end
                            end

                            uniqueGroupText = String.new

                            software.greatestVersion.uniqueOptions.each do |uniqueOptionGroup|

                                uniqueGroupText += "\n[#{ISM::Default::Option::SoftwareSearch::OptionSelectorField.colorize(Colorize::ColorRGB.new(255,100,100))}] ("

                                uniqueOptionGroup.each_with_index do |uniqueOption, index|
                                    uniqueGroupText += "#{uniqueOption.colorize(:green)}"

                                    if index+1 < uniqueOptionGroup.size
                                        uniqueGroupText += " | "
                                    else
                                        uniqueGroupText += ")\n"
                                    end
                                end

                                software.greatestVersion.options.each do |option|

                                    if uniqueOptionGroup.includes?(option.name)
                                        uniqueGroupText += "\t[#{option.active ? "*".colorize(:green) : " "}] #{option.name.colorize(:green)}: #{option.description}\n"
                                    end

                                end

                            end

                            if uniqueGroupText.empty?
                                uniqueGroupText = ISM::Default::Option::SoftwareSearch::None
                            end

                            puts    ISM::Default::Option::SoftwareSearch::OptionsField + uniqueGroupText

                            localPatchesText = ""
                            #temporary comment
                            #Dir[Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{software.versionName}/*"] do |patch|
                                #patchName = patch.lchop(patch[0..patch.rindex("/")])

                                #localPatchesText += "#{"\n\t| ".colorize(:green)}#{patchName.colorize(:yellow)}"
                            #end

                            if installedVersionText.empty?
                                installedVersionText = ISM::Default::Option::SoftwareSearch::None
                            end

                            puts    ISM::Default::Option::SoftwareSearch::LocalPatchesField + localPatchesText

                            if index < matchingSoftwaresArray.size-1
                                Ism.showSeparator
                            end
                        end

                    end

                end
            end

        end

    end

end
