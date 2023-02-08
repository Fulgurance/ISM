module ISM

    class SoftwareDependency

        property name : String
        property options : Array(ISM::SoftwareOption)

        def initialize
            @name = String.new
            @version = String.new
            @options = Array(ISM::SoftwareOption).new
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
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion < temporarySoftwareVersion && availableVersion < temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end

                        end
                    end
                end

                if lessComparator
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion > temporarySoftwareVersion && availableVersion > temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end

                if greaterOrEqualComparator
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion <= temporarySoftwareVersion && availableVersion <= temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end

                if lessOrEqualComparator
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion >= temporarySoftwareVersion && availableVersion >= temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
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

        def getDependencies : Array(ISM::SoftwareDependency)
            dependencies = Array(ISM::SoftwareDependency).new

            Ism.softwares.each do |software|

                if software.name == @name

                    software.versions.each do |softwareVersion|

                        if version == softwareVersion.version
                            dependencies = dependencies + softwareVersion.dependencies
                            break
                        end

                    end

                end
            end

            return dependencies
        end

        def getInformation : ISM::SoftwareInformation
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

        def == (other : ISM::SoftwareDependency) : Bool
            return @name == other.name &&
            SemanticVersion.parse(@version) == SemanticVersion.parse(other.version) &&
            @options == other.options
        end

    end

end
