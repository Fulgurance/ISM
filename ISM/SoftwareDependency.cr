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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def getEnabledPass : String
            @options.each do |option|
                if option.starts_with?(/Pass[0-9]/)
                    return option
                end
            end

            return String.new

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def fullName : String
            return "@#{@port}:#{@name}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def fullVersionName : String
            return "#{fullName}-#{version}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def hiddenName : String
            passName = getEnabledPass
            return "@#{@port}:#{versionName}#{passName == "" ? "" : "-#{passName}"}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def requiredVersion : String
            return @version

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def installedFiles
            softwaresList = Array(ISM::SoftwareDependency).new

            @installedSoftwares.each do |software|
                if software.toSoftwareDependency.hiddenName == hiddenName
                    return software.installedFiles
                end
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
            return information.dependencies(allowDeepSearch)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def builtSoftwareDirectoryPath : String
            return information.builtSoftwareDirectoryPath

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def requireFilePath : String
            return information.requireFilePath

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def filePath : String
            return information.filePath

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def == (other : ISM::SoftwareDependency) : Bool
            return hiddenName == other.hiddenName &&
            version == other.version &&
            @options == other.options

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
