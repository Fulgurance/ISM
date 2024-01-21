module ISM

    class SoftwareDependency

        def_clone

        include JSON::Serializable

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

        def name=(@name)
        end

        def specifiedPort : Bool
            return (/@[A-Za-z0-9\-]+:/.match(@name) != nil)
        end

        def name : String
            return specifiedPort ? @name.lchop(@name[0..@name.rindex(":")]) : @name
        end

        def fullName : String
            return specifiedPort ? @name : versionName
        end

        def fullVersionName : String
            return specifiedPort ? "#{@name}-#{version}" : versionName
        end

        def hiddenName : String
            passName = getEnabledPass
            return (passName == "" ? versionName : versionName+"-"+passName)
        end

        def version=(@version)
        end

        def versionName
            return name+"-"+version
        end

        def version
            return Ism.getAvailableSoftware(name).greatestVersion(@version).version
        end

        def requiredVersion : String
            return @version
        end

        def information : ISM::SoftwareInformation
            dependencyInformation = Ism.getSoftwareInformation(fullVersionName)

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
