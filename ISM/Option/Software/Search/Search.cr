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
                            greatestVersion = software.greatestVersion

                            puts    ISM::Default::Option::SoftwareSearch::PortField +
                                        "#{("@"+greatestVersion.port).colorize(Colorize::ColorRGB.new(255,100,100))}"

                            puts    ISM::Default::Option::SoftwareSearch::NameField +
                                        "#{software.name.colorize(:green)}"

                            puts    ISM::Default::Option::SoftwareSearch::DescriptionField +
                                        "#{greatestVersion.description.colorize(:green)}"

                            architecturesText = ""
                            greatestVersion.architectures.each_with_index do |architecture, index|
                                architecturesText += "#{architecture.colorize(:green)}"
                                if index+1 < greatestVersion.architectures.size
                                    architecturesText += " | "
                                end
                            end
                            if architecturesText.empty?
                                architecturesText = ISM::Default::Option::SoftwareSearch::None
                            end
                            puts    ISM::Default::Option::SoftwareSearch::AvailablesArchitecturesField +
                                        "#{architecturesText.colorize(:green)}"

                            puts    ISM::Default::Option::SoftwareSearch::WebsiteField +
                                        "#{greatestVersion.website.colorize(:green)}"

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
                                installedVersionText = "#{ISM::Default::Option::SoftwareSearch::None.colorize(:green)}"
                            end

                            puts    ISM::Default::Option::SoftwareSearch::InstalledVersionField +
                                        "#{installedVersionText.colorize(:green)}"

                            optionsText = String.new

                            greatestVersion.options.each do |option|

                                if greatestVersion.uniqueOptions.empty?
                                    optionsText += "\n[#{option.active ? "*".colorize(:green) : " "}] #{option.name.colorize(:green)}: #{option.description}"
                                else

                                    greatestVersion.uniqueOptions.each do |uniqueOptionGroup|

                                        if !uniqueOptionGroup.includes?(option.name)
                                            optionsText += "\n[#{option.active ? "*".colorize(:green) : " "}] #{option.name.colorize(:green)}: #{option.description}"
                                        end

                                    end
                                end
                            end

                            uniqueDependenciesSettedText = String.new

                            greatestVersion.uniqueDependencies.each do |uniqueGroup|

                                uniqueDependenciesSettedText += "\n\t"

                                uniqueGroup.each_with_index do |dependency, index|

                                    uniqueDependenciesSettedText += "#{dependency.colorize(greatestVersion.uniqueDependencyIsEnabled(dependency) ? Colorize::ColorRGB.new(255,100,100) : :dark_gray)}"

                                    if index+1 < uniqueGroup.size
                                        uniqueDependenciesSettedText += " | "
                                    end

                                end

                            end

                            puts    ISM::Default::Option::SoftwareSearch::UniqueDependenciesField +
                                    (uniqueDependenciesSettedText.empty? ? "#{ISM::Default::Option::SoftwareSearch::None.colorize(:green)}" : uniqueDependenciesSettedText)

                            uniqueGroupText = String.new

                            greatestVersion.uniqueOptions.each do |uniqueOptionGroup|

                                uniqueGroupText += "\n[#{ISM::Default::Option::SoftwareSearch::OptionSelectorField.colorize(Colorize::ColorRGB.new(255,100,100))}] ("

                                uniqueOptionGroup.each_with_index do |uniqueOption, index|
                                    uniqueGroupText += "#{uniqueOption.colorize(:green)}"

                                    if index+1 < uniqueOptionGroup.size
                                        uniqueGroupText += " | "
                                    else
                                        uniqueGroupText += ")\n"
                                    end
                                end

                                greatestVersion.options.each do |option|

                                    if uniqueOptionGroup.includes?(option.name)
                                        uniqueGroupText += "\t[#{option.active ? "*".colorize(:green) : " "}] #{option.name.colorize(:green)}: #{option.description}\n"
                                    end

                                end

                            end

                            if optionsText.empty? && uniqueGroupText.empty?
                                optionSettedText = "#{ISM::Default::Option::SoftwareSearch::None.colorize(:green)}"
                            else
                                optionSettedText = optionsText+uniqueGroupText
                            end

                            puts    ISM::Default::Option::SoftwareSearch::OptionsField + optionSettedText

                            localPatchesText = String.new

                            Dir[Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{greatestVersion.versionName}/*"].each do |patch|
                                patchName = patch.lchop(patch[0..patch.rindex("/")])

                                localPatchesText += "#{"\n\t| ".colorize(:green)}#{patchName.colorize(Colorize::ColorRGB.new(255,100,100))}"
                            end

                            if localPatchesText.empty?
                                localPatchesText = "#{ISM::Default::Option::SoftwareSearch::None.colorize(:green)}"
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
