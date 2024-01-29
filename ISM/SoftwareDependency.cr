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
            return specifiedPort ? @name[@name.index(":")..-1][1..-1] : @name
        end

        def fullVersionName : String
            return specifiedPort ? "#{@name}-#{version}" : versionName
        end

        def hiddenName : String
            passName = getEnabledPass
            return "@#{port}:#{versionName}#{passName == "" ? "" : "-#{passName}"}"
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

            if specifiedPort
                portName = @name[1..@name.index(":")][0..-2]
                dependencyInformation = ISM::SoftwareInformation.new
                dependencyInformation.loadInformationFile(  Ism.settings.rootPath +
                                                            ISM::Default::Path::SoftwaresDirectory +
                                                            portName + "/" +
                                                            name + "/" +
                                                            version + "/" +
                                                            ISM::Default::Filename::Information)
            else
                dependencyInformation = Ism.getSoftwareInformation(fullVersionName)
            end

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
