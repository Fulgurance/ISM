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
        end

        def getEnabledPass : String
            @options.each do |option|
                if option.starts_with?(/Pass[0-9]/)
                    return option
                end
            end

            return String.new

            rescue exception
                ISM::Error.show(className: "SoftwareDependency",
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
                ISM::Error.show(className: "SoftwareDependency",
                                functionName: "passEnabled",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fullName : String
            return "@#{@port}:#{@name}"
        end

        def fullVersionName : String
            if fullName.ends_with?(ISM::Default::SoftwareDependency::ChoiceKeyword)
                baseFullName = fullName.gsub(ISM::Default::SoftwareDependency::ChoiceKeyword,"")
                baseInformation = Ism.getSoftwareInformation(baseFullName)

                dependencyFullName = baseInformation.selectedDependencies[1]
                dependencyInformation = Ism.getSoftwareInformation(dependencyFullName)

                return dependencyInformation.fullVersionName
            end

            return "#{fullName}-#{version}"
        end

        def hiddenName : String
            passName = getEnabledPass
            return "@#{@port}:#{versionName}#{passName == "" ? "" : "-#{passName}"}"
        end

        def version=(@version)
        end

        def versionName
            return @name+"-"+version

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def version
            return Ism.getAvailableSoftware(fullName).greatestVersion(@version).version
        end

        def requiredVersion : String
            return @version
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
                ISM::Error.show(className: "SoftwareDependency",
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
                ISM::Error.show(className: "SoftwareDependency",
                                functionName: "installedFiles",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
            return information.dependencies(allowDeepSearch)
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
