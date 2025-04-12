module ISM

    class SoftwareDependency

        def_clone

        include JSON::Serializable

        property port : String
        property name : String
        property options : Array(String)

        def initialize( @port = String.new,
                        @name = String.new,
                        @version = String.new,
                        @options = Array(String).new)
        end

        def type : String
            return information.type

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "type",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def getEnabledPass : String
            @options.each do |option|
                if option.starts_with?(/Pass[0-9]/)
                    return option
                end
            end

            return String.new

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "getEnabledPass",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def passEnabled : Bool
            @options.each do |option|
                if ISM::SoftwareOption.isPassName(option)
                    return true
                end
            end

            return false

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "passEnabled",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def fullName : String
            return "@#{@port}:#{@name}"

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "fullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def fullVersionName : String
            return "#{fullName}-#{version}"

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "fullVersionName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def hiddenName : String
            passName = getEnabledPass
            return "@#{@port}:#{versionName}#{passName == "" ? "" : "-#{passName}"}"

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "hiddenName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def version=(@version)
        end

        def versionName
            return @name+"-"+version

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "versionName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def version
            return Ism.getAvailableSoftware(fullName).greatestVersion(@version).version

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "version",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def requiredVersion : String
            return @version

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "requiredVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def information : ISM::SoftwareInformation

            dependencyInformation = Ism.getSoftwareInformation(fullVersionName)

            if dependencyInformation.isValid

                @options.each do |option|
                    dependencyInformation.enableOption(option)
                end

            else
                dependencyInformation = ISM::SoftwareInformation.new(port: @port, name: @name, version: @version)
            end

            return dependencyInformation

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "information",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def installedFiles
            softwaresList = Array(ISM::SoftwareDependency).new

            @installedSoftwares.each do |software|
                if software.toSoftwareDependency.hiddenName == hiddenName
                    return software.installedFiles
                end
            end

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "installedFiles",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
            return information.dependencies(allowDeepSearch)

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "dependencies",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def builtSoftwareDirectoryPath : String
            return information.builtSoftwareDirectoryPath

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "builtSoftwareDirectoryPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def requireFilePath : String
            return information.requireFilePath

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "requireFilePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def filePath : String
            return information.filePath

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "filePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def == (other : ISM::SoftwareDependency) : Bool
            return hiddenName == other.hiddenName &&
            version == other.version &&
            @options == other.options

            rescue exception
            ISM::Core::Error.show(  className: "SoftwareDependency",
                                    functionName: "self == other",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

    end

end
