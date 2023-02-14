module ISM

    class SoftwareDependency

        property name : String
        property options : Array(String)

        def initialize
            @name = String.new
            @version = String.new
            @options = Array(String).new
        end

        def version=(@version)
        end

        def includeComparators : Bool
            return @version.includes?("<") || @version.includes?(">")
        end

        def greaterComparator : Bool
            return @version[0] == ">" && @version[1] != "="
        end

        def lessComparator : Bool
            return @version[0] == "<" && @version[1] != "="
        end

        def greaterOrEqualComparator : Bool
            return @version[0..1] == ">="
        end

        def lessOrEqualComparator : Bool
            return @version[0..1] == "<="
        end

        def version
            availableVersion = @version

            if includeComparators
                if greaterComparator
                    temporaryAvailableVersion = SemanticVersion.parse(@version.tr("><=",""))

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = SemanticVersion.parse(@version.tr("><=",""))

                            software.versions.each do |versionInformation|
                                temporarySoftwareVersion = SemanticVersion.parse(versionInformation.version.tr("><=",""))
                                if temporaryVersion < temporarySoftwareVersion && temporaryAvailableVersion < temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion.to_s
                                else
                                    availableVersion = @version
                                end
                            end

                        end
                    end
                end

                if lessComparator
                    temporaryAvailableVersion = SemanticVersion.parse(@version.tr("><=",""))

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = SemanticVersion.parse(@version.tr("><=",""))

                            software.versions.each do |versionInformation|
                                temporarySoftwareVersion = SemanticVersion.parse(versionInformation.version.tr("><=",""))
                                if temporaryVersion > temporarySoftwareVersion && temporaryAvailableVersion > temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion.to_s
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end

                if greaterOrEqualComparator
                    temporaryAvailableVersion = SemanticVersion.parse(@version.tr("><=",""))

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = SemanticVersion.parse(@version.tr("><=",""))

                            software.versions.each do |versionInformation|
                                temporarySoftwareVersion = SemanticVersion.parse(versionInformation.version.tr("><=",""))
                                if temporaryVersion <= temporarySoftwareVersion && temporaryAvailableVersion <= temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion.to_s
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end

                if lessOrEqualComparator
                    temporaryAvailableVersion = SemanticVersion.parse(@version.tr("><=",""))

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = SemanticVersion.parse(@version.tr("><=",""))

                            software.versions.each do |versionInformation|
                                temporarySoftwareVersion = SemanticVersion.parse(versionInformation.version.tr("><=",""))
                                if temporaryVersion >= temporarySoftwareVersion && temporaryAvailableVersion >= temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion.to_s
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end
            end

            return availableVersion
        end

        def information : ISM::SoftwareInformation
            dependencyInformation = ISM::SoftwareInformation.new

            Ism.softwares.each do |software|

                if software.name == @name

                    software.versions.each do |softwareVersion|

                        if version == softwareVersion.version
                            dependencyInformation = softwareVersion
                            break
                        end

                    end

                end
            end

            return dependencyInformation
        end

        def dependencies : Array(ISM::SoftwareDependency)
            return information.dependencies
        end

        def == (other : ISM::SoftwareDependency) : Bool
            return @name == other.name &&
            version == other.version &&
            @options == other.options
        end

    end

end
