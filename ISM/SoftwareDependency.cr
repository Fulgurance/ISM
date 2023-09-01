module ISM

    class SoftwareDependency

        def_clone

        include JSON::Serializable

        property name : String
        property options : Array(String)

        def initialize( @name = String.new,
                        @version = String.new,
                        @options = Array(String).new)
        end

        def getEnabledPass : String
            @options.each do |option|
                if option.starts_with?(/Pass[0-9]/)
                    return option
                end
            end

            return String.new
        end

        def hiddenName : String
            passName = getEnabledPass
            return (passName == "" ? versionName : versionName+"-"+passName)
        end

        def version=(@version)
        end

        def versionName
            return @name+"-"+version
        end

        def includeComparators : Bool
            return @version.includes?("<") || @version.includes?(">")
        end

        def greaterComparator : Bool
            return @version[0] == '>' && @version[1] != '='
        end

        def lessComparator : Bool
            return @version[0] == '<' && @version[1] != '='
        end

        def greaterOrEqualComparator : Bool
            return @version[0..1] == ">="
        end

        def lessOrEqualComparator : Bool
            return @version[0..1] == "<="
        end

        def version

            if includeComparators
                currentSemanticVersion = SemanticVersion.parse(@version.tr("><=",""))

                Ism.softwares.each do |software|

                    if @name == software.name

                        software.versions.each do |availableSoftware|

                            availableSoftwareSemanticVersion = SemanticVersion.parse(availableSoftware.version.tr("><=",""))

                            if greaterComparator && availableSoftwareSemanticVersion > currentSemanticVersion || lessComparator && availableSoftwareSemanticVersion < currentSemanticVersion || greaterOrEqualComparator && availableSoftwareSemanticVersion >= currentSemanticVersion || lessOrEqualComparator && availableSoftwareSemanticVersion <= currentSemanticVersion
                                return availableSoftwareSemanticVersion.to_s
                            end

                        end

                    end
                end
            end

            return @version
        end

        def information : ISM::SoftwareInformation
            dependencyInformation = Ism.getSoftwareInformation(versionName)

            @options.each do |option|
                dependencyInformation.enableOption(option)
            end

            return dependencyInformation
        end

        def installedFiles
            softwaresList = Array(ISM::SoftwareDependency).new

            @installedSoftwares.each do |software|
                if software.toSoftwareDependency.hiddenName == hiddenName
                    return software.installedFiles
                end
            end
        end

        def port : String
            return information.port
        end

        def dependencies : Array(ISM::SoftwareDependency)
            return information.dependencies
        end

        def builtSoftwareDirectoryPath : String
            return information.builtSoftwareDirectoryPath
        end

        def requireFilePath : String
            return information.requireFilePath
        end

        def filePath : String
            return information.filePath
        end

        def == (other : ISM::SoftwareDependency) : Bool
            return hiddenName == other.hiddenName &&
            version == other.version &&
            @options == other.options
        end

    end

end
