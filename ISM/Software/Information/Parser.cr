module ISM

    class Software

        class Information

            def toInformationFile(path : String)
                if File.exists?(path)
                    File.delete(path)
                else
                    finalPath = path.chomp(path[path.rindex("/")..-1])

                    if !Dir.exists?(finalPath)
                        Dir.mkdir_p(finalPath)
                    end
                end

                Parser::SectionKeywords.values.each do |section|

                    case section
                    when Parser::SectionKeywords[:port]
                        Parser.appendLineToFile(line: section, path: path)
                        Parser.appendLineToFile(line: "    #{@port}", path: path)
                    when Parser::SectionKeywords[:name]
                        Parser.appendLineToFile(line: section, path: path)
                        Parser.appendLineToFile(line: "    #{@name}", path: path)
                    when Parser::SectionKeywords[:version]
                        Parser.appendLineToFile(line: section, path: path)
                        Parser.appendLineToFile(line: "    #{@version}", path: path)
                    when Parser::SectionKeywords[:architectures]
                        Parser.appendLineToFile(line: section, path: path)

                        @architectures.each do |architecture|
                            Parser.appendLineToFile(line: "    #{architecture}", path: path)
                        end
                    when Parser::SectionKeywords[:description]
                        Parser.appendLineToFile(line: section, path: path)
                        Parser.appendLineToFile(line: "    #{@description}", path: path)
                    when Parser::SectionKeywords[:website]
                        Parser.appendLineToFile(line: section, path: path)
                        Parser.appendLineToFile(line: "    #{website}", path: path)
                    when Parser::SectionKeywords[:dependencies]
                        Parser.appendLineToFile(line: section, path: path)

                        @dependencies.each do |dependency|
                            Parser.appendLineToFile(line: "        @#{dependency.port}:#{dependency.name}#{dependency.versionDescriptor}#{dependency.options.empty? ? "" : "(#{dependency.options.join(",")})"}", path: path)
                        end
                    when Parser::SectionKeywords[:kernelDependencies]
                        Parser.appendLineToFile(line: section, path: path)

                        @kernelDependencies.each do |kernelDependency|
                            Parser.appendLineToFile(line: "    #{kernelDependency}", path: path)
                        end
                    when Parser::SectionKeywords[:options]
                        Parser.appendLineToFile(line: section, path: path)

                        @options.each do |option|
                            Parser.appendLineToFile(line: "    #{Parser::OptionKeywords[:name]}: #{option.name}", path: path)
                            Parser.appendLineToFile(line: "    #{Parser::OptionKeywords[:description]}: #{option.description}", path: path)
                            Parser.appendLineToFile(line: "    #{Parser::OptionKeywords[:active]}: #{option.active ? Parser::BoleanKeywords[:true] : Parser::BoleanKeywords[:false]}", path: path)

                            Parser.appendLineToFile(line: "    #{Parser::OptionKeywords[:dependencies]}:", path: path)
                            option.dependencies.each do |dependency|
                                Parser.appendLineToFile(line: "        @#{dependency.port}:#{dependency.name}#{dependency.versionDescriptor}#{dependency.options.empty? ? "" : "(#{dependency.options.join(",")})"}", path: path)
                            end

                            Parser.appendLineToFile(line: "    #{Parser::OptionKeywords[:kernelDependencies]}:", path: path)
                            option.kernelDependencies.each do |kernelDependency|
                                Parser.appendLineToFile(line: "        #{kernelDependency}", path: path)
                            end

                            Parser.appendLineToFile(line: "", path: path)
                        end
                    when Parser::SectionKeywords[:uniqueDependencies]
                        Parser.appendLineToFile(line: section, path: path)

                        @uniqueDependencies.each do |uniqueSet|
                            Parser.appendLineToFile(line: "    #{uniqueSet.join(",")}", path: path)
                        end
                    when Parser::SectionKeywords[:uniqueOptions]
                        Parser.appendLineToFile(line: section, path: path)

                        @uniqueOptions.each do |uniqueSet|
                            Parser.appendLineToFile(line: "    #{uniqueSet.join(",")}", path: path)
                        end
                    when Parser::SectionKeywords[:allowCodependencies]
                        Parser.appendLineToFile(line: section, path: path)

                        @allowCodependencies.each do |codependency|
                            Parser.appendLineToFile(line: "    #{codependency}", path: path)
                        end
                    else
                        raise "Unknown section: #{section}.Aborted !"
                    end
                end
            end

            module Parser

                SectionKeywords = { :port => "PORT",
                                    :name => "NAME",
                                    :version => "VERSION",
                                    :architectures => "ARCHITECTURES",
                                    :description => "DESCRIPTION",
                                    :website => "WEBSITE",
                                    :installedFiles => "INSTALLEDFILES",
                                    :dependencies => "DEPENDENCIES",
                                    :kernelDependencies => "KERNELDEPENDENCIES",
                                    :options => "OPTIONS",
                                    :uniqueDependencies => "UNIQUEDEPENDENCIES",
                                    :uniqueOptions => "UNIQUEOPTIONS",
                                    :selectedDependencies => "SELECTEDDEPENDENCIES"
                                    :allowCodependencies => "ALLOWCODEPENDENCIES"}

                OptionKeywords = {  :name => "name",
                                    :description => "description",
                                    :active => "active",
                                    :dependencies => "dependencies",
                                    :kernelDependencies => "kernelDependencies"}

                ConditionKeywords = {   :if => "if",
                                        :elsif => "elsif",
                                        :else => "else",
                                        :end => "end"}

                LogicalKeywords = { :and => "&&",
                                    :or => "||"}

                ComparatorKeywords = {  :equal => "=",
                                        :lessOrEqual => "<=",
                                        :greaterOrEqual => ">=",
                                        :less => "<",
                                        :greater => ">",
                                        :selected => "selected"}

                APIKeywords = { :component => "component",
                                :software => "software"}

                APIKeywordsFilters = {:component => /(#{APIKeywords[:component]}\(\"[\w-]+\"\))/}

                BoleanKeywords = {  :true => "true",
                                    :false => "false"}

                ComparatorGroupFilter = "#{ComparatorKeywords.values.join("|")}"
                APIKeywordsGroupFilter = "#{APIKeywordsFilters.values.join("|")}"
                BoleanGroupFilter = "#{BoleanKeywords.values.join("|")}"

                ComparisonFilter1 = /#{APIKeywordsGroupFilter}/
                ComparisonFilter2 = /\"[\s\S]+\"/
                ComparisonFilter = /(#{ComparisonFilter1})\s+(#{ComparatorGroupFilter})\s+(#{ComparisonFilter2})/

                AndFilter = /\s+#{LogicalKeywords[:and].split.map {|char| "\\#{char}"}.join}\s+(#{ComparisonFilter})/
                OrFilter = /\s+#{LogicalKeywords[:or].split.map {|char| "\\#{char}"}.join}\s+(#{ComparisonFilter})/

                IfFilter = /\A#{ConditionKeywords[:if]}\s+#{ComparisonFilter}((#{AndFilter})|(#{OrFilter}))*\z/
                ElsifFilter = /\A#{ConditionKeywords[:elsif]}\s+#{ComparisonFilter}((#{AndFilter})|(#{OrFilter}))*\z/
                ElseFilter = /\A\s*#{ConditionKeywords[:else]}\s*\z/
                EndFilter = /\A\s*#{ConditionKeywords[:end]}\s*\z/

                PortFilter = /\A[\w-]+\z/
                NameFilter = /\A[\w-]+\z/
                VersionFilter = /\A[\w.-]+\z/
                ArchitecturesFilter = /\A\w+\z/
                DescriptionFilter = /\A[\s\S]+\z/
                WebsiteFilter = /\A[\s\S]+\z/

                VersionDescriptorFilter = /((#{ComparatorGroupFilter})[\w.\-\+]+(\s\~\s(#{ComparatorGroupFilter})[\w.\-\+]+)?)/
                OptionsFilter = /(\([\w.-]*(,[\w.-]*)*\))?/
                DependencyFilter = /\A@[\w-]+:[\w-]+\z/
                DependencyVersionFilter = /\A@[\w-]+:[\w-]+#{VersionDescriptorFilter}\z/
                DependencyVersionWithOptionsFilter = /\A@[\w-]+:[\w-]+#{VersionDescriptorFilter}#{OptionsFilter}\z/

                KernelDependenciesFilter = /\ACONFIG_\w+\z/

                OptionFieldKeywords = { :name => "name",
                                        :description => "description",
                                        :active => "active",
                                        :dependencies => "dependencies",
                                        :kernelDependencies => "kernelDependencies"}
                OptionNameFilter = /#{OptionFieldKeywords[:name]}:\s+[\w-]/
                OptionDescriptionFilter = /#{OptionFieldKeywords[:description]}:\s+[\w-]/
                OptionActiveFilter = /#{OptionFieldKeywords[:active]}:\s+(#{BoleanGroupFilter})/
                OptionDependenciesFilter = /#{OptionFieldKeywords[:dependencies]}:\s*/
                OptionKernelDependenciesFilter = /#{OptionFieldKeywords[:kernelDependencies]}:\s*/

                AllowCodependenciesFilter = DependencyFilter

                def self.fromInformationFile(path : String) : Information
                    file = File.read_lines(path)

                    currentSection = String.new
                    currentIfLevel = 0
                    ifLevelsValidity = Array(Bool).new
                    currentOption = Hash(String, String).new
                    underOptionDependenciesSubSection = false
                    underOptionKernelDependenciesSubSection = false
                    currentOptionDependencies = Array(Dependency).new
                    currentOptionKernelDependencies = Array(String).new

                    port = String.new
                    name = String.new
                    version = String.new
                    architectures = Array(String).new
                    description = String.new
                    website = String.new
                    installedFiles = Array(String).new
                    dependencies = Array(Dependency).new
                    kernelDependencies = Array(String).new
                    options = Array(Option).new
                    uniqueDependencies = Array(Array(String)).new
                    uniqueOptions = Array(Array(String)).new
                    selectedDependencies = Array(String).new
                    allowCodependencies = Array(String).new

                    file.each_with_index do |line, index|

                        strippedLine = line.strip

                        if !strippedLine.empty?

                            #Update the current section
                            if Parser::SectionKeywords.values.any? { |entry| entry == line}
                                currentSection = line
                            end

                            #Error if the first line is not a section
                            if currentSection.empty?
                                raise("Line #{index+1}\nFile: #{path}\nInvalid section: #{line}\nThe first line must declare a valid section.")
                            end

                            #When we are not declaring a section (under a section)
                            if !Parser::SectionKeywords.values.any? { |entry| entry == line}
                                case currentSection
                                when Parser::SectionKeywords[:port]
                                    #It is the line declaration for port
                                    #We ensure the port name pass the filter
                                    if port.empty?
                                        if Parser::PortFilter.matches?(strippedLine)
                                            port = strippedLine
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared port use an illegal character.")
                                        end
                                    else
                                        #Port already defined
                                        raise("Line #{index+1}\nFile: #{path}\nInvalid line: #{line}\nThe port has already been defined.")
                                    end
                                when Parser::SectionKeywords[:name]
                                    #It is the line declaration for name
                                    #We ensure the name pass the filter
                                    if name.empty?
                                        if Parser::NameFilter.matches?(strippedLine)
                                            name = strippedLine
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared name use an illegal character.")
                                        end
                                    else
                                        #Name already defined
                                        raise("Line #{index+1}\nFile: #{path}\nInvalid line: #{line}\nThe name has already been defined.")
                                    end
                                when Parser::SectionKeywords[:version]
                                    #It is the line declaration for version
                                    #We ensure the version pass the filter
                                    if version.empty?
                                        if Parser::VersionFilter.matches?(strippedLine)
                                            version = strippedLine
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared version use an illegal character.")
                                        end
                                    else
                                        #Version already defined
                                        raise("Line #{index+1}\nFile: #{path}\nInvalid line: #{line}\nThe version has already been defined.")
                                    end
                                when Parser::SectionKeywords[:architectures]
                                    #It is the line declaration for architectures
                                    #We ensure the architectures pass the filter
                                    if Parser::ArchitecturesFilter.matches?(strippedLine)
                                        architectures.push(strippedLine)
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared architecture list used an illegal character or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:description]
                                    #It is the line declaration for description
                                    #We ensure the description pass the filter
                                    if description.empty?
                                        if Parser::DescriptionFilter.matches?(strippedLine)
                                            description = strippedLine
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared description use an illegal character.")
                                        end
                                    else
                                        #Description already defined
                                        raise("Line #{index+1}\nFile: #{path}\nInvalid line: #{line}\nThe description has already been defined.")
                                    end
                                when Parser::SectionKeywords[:website]
                                    #It is the line declaration for website
                                    #We ensure the website pass the filter
                                    if website.empty?
                                        if Parser::WebsiteFilter.matches?(strippedLine)
                                            website = strippedLine
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared website use an illegal character.")
                                        end
                                    else
                                        #Website already defined
                                        raise("Line #{index+1}\nFile: #{path}\nInvalid line: #{line}\nThe website has already been defined.")
                                    end
                                when Parser::SectionKeywords[:installedFiles]
                                    #It is the line declaration for installedFiles
                                    #We ensure the installedFiles pass the filter
                                    #if Parser::InstalledFilesFilter.matches?(strippedLine)
                                        installedFiles.push(strippedLine)
                                    #else
                                    #    raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared installed file list used an illegal character or is not declared properly.")
                                    #end
                                when Parser::SectionKeywords[:dependencies]
                                    #It is the line declaration for dependencies
                                    #We ensure the dependencies pass the filter
                                    if Parser::DependencyVersionFilter.matches?(strippedLine) || Parser::DependencyVersionWithOptionsFilter.matches?(strippedLine)
                                        if currentIfLevel == 0 || currentIfLevel > 0 && !ifLevelsValidity[0..currentIfLevel-1].any? { |entry| entry == false }
                                            dependencies.push(parseDependencyDescriptor(strippedLine))
                                        end
                                    elsif Parser::IfFilter.matches?(strippedLine)

                                        currentIfLevel += 1

                                        ifLevelsValidity.push(parseCondition(conditions: strippedLine.gsub(/\A#{Parser::ConditionKeywords[:if]}\s+/,"")))
                                    elsif Parser::ElsifFilter.matches?(strippedLine)

                                    elsif Parser::ElseFilter.matches?(strippedLine)

                                    elsif Parser::EndFilter.matches?(strippedLine)
                                        if currentIfLevel == 0
                                            raise("Line #{index+1}\nFile: #{path}\nExtra end: #{line}\n.An extra end section is declared.")
                                        else
                                            currentIfLevel -= 1
                                        end
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared dependency list used an illegal character or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:kernelDependencies]
                                    #It is the line declaration for kernelDependencies
                                    #We ensure the kernelDependencies pass the filter
                                    if Parser::KernelDependenciesFilter.matches?(strippedLine)
                                        kernelDependencies.push(strippedLine)
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared kernel dependency list used an illegal character or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:options]
                                    if currentOption.has_key?(Parser::OptionFieldKeywords[:name]) && currentOption.has_key?(Parser::OptionFieldKeywords[:description]) && currentOption.has_key?(Parser::OptionFieldKeywords[:active]) && Parser::OptionNameFilter.matches?(strippedLine)
                                        options.push(Option.new(currentOption[Parser::OptionFieldKeywords[:name]],
                                                                currentOption[Parser::OptionFieldKeywords[:description]],
                                                                (currentOption[Parser::OptionFieldKeywords[:active]] == Parser::BoleanKeywords[:true]),
                                                                currentOptionDependencies.dup,
                                                                currentOptionKernelDependencies.dup))
                                    end

                                    if Parser::OptionNameFilter.matches?(strippedLine)
                                        underOptionDependenciesSubSection = false
                                        underOptionKernelDependenciesSubSection = false

                                        currentOption[Parser::OptionFieldKeywords[:name]] = strippedLine.gsub(/\A#{Parser::OptionFieldKeywords[:name]}:\s+/,"")
                                    elsif Parser::OptionDescriptionFilter.matches?(strippedLine)
                                        underOptionDependenciesSubSection = false
                                        underOptionKernelDependenciesSubSection = false

                                        currentOption[Parser::OptionFieldKeywords[:description]] = strippedLine.gsub(/\A#{Parser::OptionFieldKeywords[:description]}:\s+/,"")
                                    elsif Parser::OptionActiveFilter.matches?(strippedLine)
                                        underOptionDependenciesSubSection = false
                                        underOptionKernelDependenciesSubSection = false

                                        currentOption[Parser::OptionFieldKeywords[:active]] = strippedLine.gsub(/\A#{Parser::OptionFieldKeywords[:active]}:\s+/,"")
                                    elsif Parser::OptionDependenciesFilter.matches?(strippedLine)
                                        underOptionDependenciesSubSection = true
                                        underOptionKernelDependenciesSubSection = false

                                        currentOptionDependencies.clear
                                    elsif Parser::OptionKernelDependenciesFilter.matches?(strippedLine)
                                        underOptionDependenciesSubSection = false
                                        underOptionKernelDependenciesSubSection = true

                                        currentOptionKernelDependencies.clear
                                    elsif underOptionDependenciesSubSection
                                        if Parser::DependencyVersionFilter.matches?(strippedLine) || Parser::DependencyVersionWithOptionsFilter.matches?(strippedLine)
                                            currentOptionDependencies.push(parseDependencyDescriptor(strippedLine))
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared dependency list used an illegal character or is not declared properly.")
                                        end
                                    elsif underOptionKernelDependenciesSubSection
                                        if Parser::KernelDependenciesFilter.matches?(strippedLine)
                                            currentOptionKernelDependencies.push(strippedLine)
                                        else
                                            raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared kernel dependency used an illegal character or is not declared properly.")
                                        end
                                    else

                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared option list used an illegal character or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:uniqueDependencies]
                                    #We first ensure the last previous option from the previous section is added if there is any
                                    if !currentOption.empty?
                                        options.push(Option.new(currentOption[Parser::OptionFieldKeywords[:name]],
                                                                currentOption[Parser::OptionFieldKeywords[:description]],
                                                                (currentOption[Parser::OptionFieldKeywords[:active]] == Parser::BoleanKeywords[:true]),
                                                                currentOptionDependencies.dup,
                                                                currentOptionKernelDependencies.dup))
                                    end

                                    #Special case: filter generated dynamically to check if we pass a valid dependency
                                    dependenciesFilter = /(#{dependencies.map {|dependency| dependency.fullName}.join("|")})/
                                    filter = /\A#{dependenciesFilter}(,#{dependenciesFilter})*\z/

                                    if filter.matches?(strippedLine)
                                        uniqueDependencies.push(strippedLine.split(","))
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared unique dependency list used an illegal character, used non valid dependency or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:uniqueOptions]
                                    #Special case: filter generated dynamically to check if we pass a valid option
                                    optionsFilter = /(#{options.map {|option| option.name}.join("|")})/
                                    filter = /\A#{optionsFilter}(,#{optionsFilter})*\z/

                                    if filter.matches?(strippedLine)
                                        uniqueOptions.push(strippedLine.split(","))
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared unique option list used an illegal character, used non-existent option or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:selectedDependencies]
                                    #Special case: filter generated dynamically to check if we pass a valid unique dependency
                                    dependenciesFilter = /(#{uniqueDependencies.flatten.uniq.join("|")})/
                                    filter = /\A#{dependenciesFilter}(,#{dependenciesFilter})*\z/

                                    if filter.matches?(strippedLine)
                                        uniqueDependencies.push(strippedLine.split(","))
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared unique option list used an illegal character, used non-existent option or is not declared properly.")
                                    end
                                when Parser::SectionKeywords[:allowCodependencies]
                                    if Parser::AllowCodependenciesFilter.matches?(strippedLine)
                                        allowCodependencies.push(strippedLine)
                                    else
                                        raise("Line #{index+1}\nFile: #{path}\nIllegal character: #{line}\nThe declared allowed codependency list used an illegal character or is not declared properly.")
                                    end
                                else

                                end
                            end

                        end

                    end

                    return Information.new( port,
                                            name,
                                            version,
                                            architectures,
                                            description,
                                            website,
                                            installedFiles,
                                            dependencies,
                                            kernelDependencies,
                                            options,
                                            uniqueDependencies,
                                            uniqueOptions,
                                            selectedDependencies,
                                            allowCodependencies)
                end

                def self.parseDependencyDescriptor(descriptor : String) : Dependency
                    port = descriptor[1..-1].partition(':').first
                    name = descriptor.gsub("@#{port}:","").partition(/[>=<]+/).first
                    options = descriptor.partition('(').last.gsub(")","").split(",").reject { |entry| entry.empty? }
                    version = descriptor.gsub("@#{port}:#{name}","").partition('(').first

                    return Dependency.new(port,name,version,options)
                end

                #Parse a single comparison
                #Note: no need to check the structure, because was already tested previously
                def self.parseComparison(comparison : String) : Bool
                    comparator = comparison.match(/(#{Parser::ComparatorGroupFilter})/).to_s

                    case comparator
                    when Parser::ComparatorKeywords[:selected]
                        values = comparison.split(/\s+#{Parser::ComparatorKeywords[:selected]}\s+/)

                        stringFilter = /\(\"[\s\S]*\"\)/

                        value1 = values[0].match(/(#{Parser::APIKeywordsGroupFilter})/).to_s
                        keyword1 = value1.gsub(stringFilter,"")
                        string1 = value1.match(stringFilter).to_s[1..-2]

                        case keyword1
                        when Parser::APIKeywords[:component]
                            component = Ism.getSoftwareInformation( userEntry: string1,
                                                                    allowSearchByNameOnly: true,
                                                                    searchComponentsOnly: true)

                            return component.uniqueDependencyIsEnabled(values[1])
                        when Parser::APIKeywords[:software]
                            software = Ism.getSoftwareInformation(  userEntry: string1,
                                                                    allowSearchByNameOnly: true,
                                                                    searchComponentsOnly: false)

                            return software.uniqueDependencyIsEnabled(values[1])
                        else
                            raise "Unknow keyword: #{keyword1}\nfor comparison: #{comparison}"
                        end
                    else
                        raise "Unknow comparator: #{comparator}\nfor comparison: #{comparison}"
                    end
                end

                #Parse multiple comparisons with AND comparator
                #Note: no need to check the structure, because was already tested previously
                def self.parseComparisonGroup(conditions : String) : Bool
                    filter = /\s+(?:#{Parser::LogicalKeywords[:and].split.map {|char| "\\#{char}"}.join})\s+/

                    comparisons = conditions.split( filter,
                                                    remove_empty: true)

                    comparisons.each do |comparison|
                        if parseComparison(comparison) == false
                            return false
                        end
                    end

                    return true
                end

                #Parse multiple comparisons with logical comparator (&&,||).
                #Note: no need to check the structure, because was already tested previously
                def self.parseCondition(conditions : String) : Bool
                    filter = /\s+(?:#{Parser::LogicalKeywords[:or].split.map {|char| "\\#{char}"}.join})\s+/

                    comparisonGroups = conditions.split(filter,
                                                        remove_empty: true)

                    comparisonGroups.each do |comparisonGroup|
                        if parseComparisonGroup(comparisonGroup) == true
                            return true
                        end
                    end

                    return false
                end

                def self.appendLineToFile(line : String, path : String)
                    File.write(path,"#{line}\n", mode: "a")
                end

            end

        end

    end

end
