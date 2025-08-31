module ISM

    module Option

        class Software

            class Search < ISM::CommandLineOption

                module Default

                    ShortText = "-se"
                    LongText = "search"
                    Description = "Search specific(s) software(s)"
                    NoMatchFound = "No match found with the database for "
                    NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                    None = "None"
                    TypeField = "Type: "
                    PortField = "Port: "
                    NameField = "Name: "
                    DescriptionField = "Description: "
                    AvailablesArchitecturesField = "Available(s) architecture(s): "
                    WebsiteField = "Website: "
                    AvailablesVersionsField = "Available(s) Version(s): "
                    InstalledVersionField = "Installed Version(s): "
                    UniqueDependenciesField = "Unique dependencies setted: "
                    OptionsField = "Current options setted: "
                    OptionSelectorField = "Selector"
                    LocalPatchesField = "Current local patches: "

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        showHelp
                    else
                        matchingSoftwaresArray = Array(ISM::AvailableSoftware).new

                        #Need improvement by using directly getRequestedSoftwares(list : Array(String), allowSearchByNameOnly = false)
                        Ism.softwares.each do |software|
                            if software.name.includes?(ARGV[2]) || software.name.downcase.includes?(ARGV[2])
                                matchingSoftwaresArray << software
                            end
                        end

                        if matchingSoftwaresArray.empty?
                            puts Default::NoMatchFound + "#{ARGV[2].colorize(:green)}"
                            puts Default::NoMatchFoundAdvice
                        else
                            puts "\n"

                            matchingSoftwaresArray.each_with_index do |software, index|
                                greatestVersion = software.greatestVersion

                                puts    Default::TypeField +
                                            "#{(greatestVersion.type).colorize(:magenta)}"

                                puts    Default::PortField +
                                            "#{("@"+greatestVersion.port).colorize(Colorize::ColorRGB.new(255,100,100))}"

                                puts    Default::NameField +
                                            "#{greatestVersion.name.colorize(:green)}"

                                puts    Default::DescriptionField +
                                            "#{greatestVersion.description.colorize(:green)}"

                                architecturesText = ""
                                greatestVersion.architectures.each_with_index do |architecture, index|
                                    architecturesText += architecture
                                    if index+1 < greatestVersion.architectures.size
                                        architecturesText += " | "
                                    end
                                end
                                if architecturesText.empty?
                                    architecturesText = Default::None
                                end
                                puts    Default::AvailablesArchitecturesField +
                                            "#{architecturesText.colorize(Colorize::ColorRGB.new(255,170,0))}"

                                puts    Default::WebsiteField +
                                            "#{greatestVersion.website.colorize(:green)}"

                                versionsText = ""
                                software.versions.each_with_index do |version, index|
                                    versionsText += "#{version.version.colorize(:green)}"
                                    if index+1 < software.versions.size
                                            versionsText += " | "
                                    end
                                end
                                puts    Default::AvailablesVersionsField +
                                            "#{versionsText}"

                                installedVersionText = ""
                                Ism.installedSoftwares.each_with_index do |installed, index|
                                    if software.fullName == installed.fullName
                                        installedVersionText += "#{"\n\t| ".colorize(:green)}"

                                        #TO DO
                                        #.colorize(Colorize::ColorRGB.new(255,100,100)).back(:green).bold
                                        installedVersionText += "#{installed.version.colorize(Colorize::ColorRGB.new(255,100,100))}"

                                        installedVersionText += " { "

                                        if installed.options.empty?
                                            installedVersionText += "#{"#{CommandLine::Default::NoOptionText} ".colorize(:dark_gray)}"
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
                                    installedVersionText = "#{Default::None.colorize(:green)}"
                                end

                                puts    Default::InstalledVersionField +
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

                                puts    Default::UniqueDependenciesField +
                                        (uniqueDependenciesSettedText.empty? ? "#{Default::None.colorize(:green)}" : uniqueDependenciesSettedText)

                                uniqueGroupText = String.new

                                greatestVersion.uniqueOptions.each do |uniqueOptionGroup|

                                    uniqueGroupText += "\n[#{Default::OptionSelectorField.colorize(Colorize::ColorRGB.new(255,100,100))}] ("

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
                                    optionSettedText = "#{Default::None.colorize(:green)}"
                                else
                                    optionSettedText = optionsText+uniqueGroupText
                                end

                                puts    Default::OptionsField + optionSettedText

                                localPatchesText = String.new

                                Dir[Ism.settings.rootPath+Path::PatchesDirectory+"/#{greatestVersion.versionName}/*"].each do |patch|
                                    patchName = patch.lchop(patch[0..patch.rindex("/")])

                                    localPatchesText += "#{"\n\t| ".colorize(:green)}#{patchName.colorize(Colorize::ColorRGB.new(255,100,100))}"
                                end

                                if localPatchesText.empty?
                                    localPatchesText = "#{Default::None.colorize(:green)}"
                                end

                                puts    Default::LocalPatchesField + localPatchesText

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

end
