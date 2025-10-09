module ISM

    class Software

        class Information

            module Parser

                SectionKeywords = { :port => "PORT",
                                    :name => "NAME",
                                    :version => "VERSION",
                                    :architecture => "ARCHITECTURE",
                                    :description => "DESCRIPTION",
                                    :website => "WEBSITE",
                                    :dependencies => "DEPENDENCIES",
                                    :kernelDependencies => "KERNELDEPENDENCIES",
                                    :options => "OPTIONS",
                                    :uniqueDependencies => "UNIQUEDEPENDENCIES",
                                    :uniqueOptions => "UNIQUEOPTIONS",
                                    :allowCodependencies => "ALLOWCODEPENDENCIES"}

                OptionKeywords = {  :name => "name:",
                                    :description => "description:",
                                    :active => "active:",
                                    :dependencies => "dependencies:"}

                PortFilter = /\b[A-Za-z0-9-]+\b/
                NameFilter = /\b[A-Za-z0-9-]+\b/
                VersionFilter = /\b[A-Za-z0-9.-]+\b/
                ArchitectureFilter = /\A\s*\w+(,\w+)*\z/
                DescriptionFilter = /\b[\s\S]+\b/
                WebsiteFilter = /\b[\s\S]+\b/

                DependencyFilter = /@[A-Za-z0-9-]+:[A-Za-z0-9-]+(>=|<=|=|>|<)[A-Za-z0-9.-]+/

            end

            def self.fromInformationFile(path : String) : Information
                file = File.read_lines(path)

                currentSection = String.new

                port = String.new
                name = String.new
                version = String.new
                architecture = String.new
                description = String.new
                website = String.new
                dependencies = Array(Software::Dependency).new
                kernelDependencies = Array(String).new
                options = Array(Software::Option).new
                uniqueDependencies = Array(Array(String)).new
                uniqueOptions = Array(Array(String)).new
                selectedDependencies = Array(String).new
                allowCodependencies = Array(String).new

                file.each_with_index do |line, index|

                    #Update the current section
                    if SectionKeywords.values.any? { |entry| entry == line}
                        currentSection = line
                    end

                    #Error if the first line is not a section
                    if currentSection.empty?
                        raise("Line #{index+1}\nInvalid section: #{line}\nThe first line must declare a valid section.")
                    end

                    #When we are not declaring a section (under a section)
                    if !Parser::SectionKeywords.values.any? { |entry| entry == line}
                        case currentSection
                        when Parser::SectionKeywords[:port]
                            #It is the line declaration for port
                            #We ensure the port name pass the filter
                            if port.empty?
                                if Parser::PortFilter.matches?(line)
                                    port = line
                                else
                                    raise("Line #{index+1}\nIllegal character: #{line}\nThe declared port use an illegal character.")
                                end
                            else
                                #Port already defined
                                raise("Line #{index+1}\nInvalid line: #{line}\nThe port has already been defined.")
                            end
                        when Parser::SectionKeywords[:name]
                            #It is the line declaration for name
                            #We ensure the name pass the filter
                            if name.empty?
                                if Parser::NameFilter.matches?(line)
                                    name = line
                                else
                                    raise("Line #{index+1}\nIllegal character: #{line}\nThe declared name use an illegal character.")
                                end
                            else
                                #Name already defined
                                raise("Line #{index+1}\nInvalid line: #{line}\nThe name has already been defined.")
                            end
                        when Parser::SectionKeywords[:version]
                            #It is the line declaration for version
                            #We ensure the version pass the filter
                            if version.empty?
                                if Parser::VersionFilter.matches?(line)
                                    version = line
                                else
                                    raise("Line #{index+1}\nIllegal character: #{line}\nThe declared version use an illegal character.")
                                end
                            else
                                #Version already defined
                                raise("Line #{index+1}\nInvalid line: #{line}\nThe version has already been defined.")
                            end
                        when Parser::SectionKeywords[:architecture]
                            #It is the line declaration for architecture
                            #We ensure the architecture pass the filter
                            if architecture.empty?
                                if Parser::ArchitectureFilter.matches?(line)
                                    architecture = line
                                else
                                    raise("Line #{index+1}\nIllegal character: #{line}\nThe declared architecture use an illegal character.")
                                end
                            else
                                #Architecture already defined
                                raise("Line #{index+1}\nInvalid line: #{line}\nThe architecture has already been defined.")
                            end
                        when Parser::SectionKeywords[:description]
                            #It is the line declaration for description
                            #We ensure the description pass the filter
                            if description.empty?
                                if Parser::DescriptionFilter.matches?(line)
                                    description = line
                                else
                                    raise("Line #{index+1}\nIllegal character: #{line}\nThe declared description use an illegal character.")
                                end
                            else
                                #Description already defined
                                raise("Line #{index+1}\nInvalid line: #{line}\nThe description has already been defined.")
                            end
                        when Parser::SectionKeywords[:website]
                            #It is the line declaration for website
                            #We ensure the website pass the filter
                            if website.empty?
                                if Parser::WebsiteFilter.matches?(line)
                                    website = line
                                else
                                    raise("Line #{index+1}\nIllegal character: #{line}\nThe declared website use an illegal character.")
                                end
                            else
                                #Website already defined
                                raise("Line #{index+1}\nInvalid line: #{line}\nThe website has already been defined.")
                            end
                        when Parser::SectionKeywords[:dependencies]

                        when Parser::SectionKeywords[:kernelDependencies]

                        when Parser::SectionKeywords[:options]

                        when Parser::SectionKeywords[:uniqueDependencies]

                        when Parser::SectionKeywords[:uniqueOptions]

                        when Parser::SectionKeywords[:allowCodependencies]

                        else

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

        end

    end

end
