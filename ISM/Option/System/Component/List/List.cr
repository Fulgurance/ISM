module ISM

    module Option

        class ComponentList < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::ComponentList::ShortText,
                        ISM::Default::Option::ComponentList::LongText,
                        ISM::Default::Option::ComponentList::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    matchingComponentsArray = Array(ISM::AvailableComponent).new

                    #Need improvement by using directly getRequestedComponents(list : Array(String), allowListByNameOnly = false)
                    Ism.softwares.each do |software|
                        if software.name.includes?(ARGV[2]) || software.name.downcase.includes?(ARGV[2])
                            matchingComponentsArray << software
                        end
                    end

                    if matchingComponentsArray.empty?
                        puts ISM::Default::Option::ComponentList::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                        puts ISM::Default::Option::ComponentList::NoMatchFoundAdvice
                    else
                        puts "\n"

                        matchingComponentsArray.each_with_index do |software, index|
                            greatestVersion = software.greatestVersion

                            puts    ISM::Default::Option::ComponentList::TypeField +
                                        "#{(greatestVersion.type).colorize(:magenta)}"

                            puts    ISM::Default::Option::ComponentList::PortField +
                                        "#{("@"+greatestVersion.port).colorize(Colorize::ColorRGB.new(255,100,100))}"

                            puts    ISM::Default::Option::ComponentList::NameField +
                                        "#{greatestVersion.name.colorize(:green)}"

                            puts    ISM::Default::Option::ComponentList::DescriptionField +
                                        "#{greatestVersion.description.colorize(:green)}"

                            architecturesText = ""
                            greatestVersion.architectures.each_with_index do |architecture, index|
                                architecturesText += architecture
                                if index+1 < greatestVersion.architectures.size
                                    architecturesText += " | "
                                end
                            end
                            if architecturesText.empty?
                                architecturesText = ISM::Default::Option::ComponentList::None
                            end
                            puts    ISM::Default::Option::ComponentList::AvailablesArchitecturesField +
                                        "#{architecturesText.colorize(Colorize::ColorRGB.new(255,170,0))}"

                            puts    ISM::Default::Option::ComponentList::WebsiteField +
                                        "#{greatestVersion.website.colorize(:green)}"

                            versionsText = ""
                            software.versions.each_with_index do |version, index|
                                versionsText += "#{version.version.colorize(:green)}"
                                if index+1 < software.versions.size
                                        versionsText += " | "
                                end
                            end
                            puts    ISM::Default::Option::ComponentList::AvailablesVersionsField +
                                        "#{versionsText}"

                            installedVersionText = ""
                            Ism.installedComponents.each_with_index do |installed, index|
                                if software.fullName == installed.fullName
                                    installedVersionText += "#{"\n\t| ".colorize(:green)}"
                                    installedVersionText += "#{installed.version.colorize(Colorize::ColorRGB.new(255,100,100))}"

                                    installedVersionText += " { "

                                    if installed.options.empty?
                                        installedVersionText += "#{"#{ISM::Default::CommandLine::NoOptionText} ".colorize(:dark_gray)}"
                                    end

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
                                installedVersionText = "#{ISM::Default::Option::ComponentList::None.colorize(:green)}"
                            end

                            puts    ISM::Default::Option::ComponentList::InstalledVersionField +
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

                            puts    ISM::Default::Option::ComponentList::UniqueDependenciesField +
                                    (uniqueDependenciesSettedText.empty? ? "#{ISM::Default::Option::ComponentList::None.colorize(:green)}" : uniqueDependenciesSettedText)

                            uniqueGroupText = String.new

                            greatestVersion.uniqueOptions.each do |uniqueOptionGroup|

                                uniqueGroupText += "\n[#{ISM::Default::Option::ComponentList::OptionSelectorField.colorize(Colorize::ColorRGB.new(255,100,100))}] ("

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
                                optionSettedText = "#{ISM::Default::Option::ComponentList::None.colorize(:green)}"
                            else
                                optionSettedText = optionsText+uniqueGroupText
                            end

                            puts    ISM::Default::Option::ComponentList::OptionsField + optionSettedText

                            localPatchesText = String.new

                            Dir[Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{greatestVersion.versionName}/*"].each do |patch|
                                patchName = patch.lchop(patch[0..patch.rindex("/")])

                                localPatchesText += "#{"\n\t| ".colorize(:green)}#{patchName.colorize(Colorize::ColorRGB.new(255,100,100))}"
                            end

                            if localPatchesText.empty?
                                localPatchesText = "#{ISM::Default::Option::ComponentList::None.colorize(:green)}"
                            end

                            puts    ISM::Default::Option::ComponentList::LocalPatchesField + localPatchesText

                            if index < matchingComponentsArray.size-1
                                Ism.showSeparator
                            end
                        end

                    end

                end
            end

        end

    end

end
