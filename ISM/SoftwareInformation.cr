module ISM

  class SoftwareInformation

    def_clone

    include JSON::Serializable

    property port : String
    property name : String
    property version : String
    property architectures : Array(String)
    property description : String
    property website : String
    property installedFiles : Array(String)
    setter dependencies : Array(ISM::SoftwareDependency)
    setter kernelDependencies : Array(String)
    property options : Array(ISM::SoftwareOption)
    property uniqueDependencies : Array(Array(String))
    property uniqueOptions : Array(Array(String))
    property selectedDependencies : Array(String)
    property allowCodependencies : Array(String)

    def initialize( @port = String.new,
                    @name = String.new,
                    @version = String.new,
                    @architectures = Array(String).new,
                    @description = String.new,
                    @website = String.new,
                    @installedFiles = Array(String).new,
                    @dependencies = Array(ISM::SoftwareDependency).new,
                    @kernelDependencies = Array(String).new,
                    @options = Array(ISM::SoftwareOption).new,
                    @uniqueDependencies = Array(Array(String)).new,
                    @uniqueOptions = Array(Array(String)).new,
                    @selectedDependencies = Array(String).new,
                    @allowCodependencies = Array(String).new)
    end

    def self.loadConfiguration(path : String)
        begin
            return from_json(File.read(path))
        rescue error : JSON::ParseException
            puts    "#{ISM::Default::SoftwareInformation::FileLoadProcessSyntaxErrorText1 +
                    path +
                    ISM::Default::SoftwareInformation::FileLoadProcessSyntaxErrorText2 +
                    error.line_number.to_s}".colorize(:yellow)
            return self.new
        end
    end

    def writeConfiguration(path : String)
        finalPath = path.chomp(path[path.rindex("/")..-1])

        if !Dir.exists?(finalPath)
            Dir.mkdir_p(finalPath)
        end

        file = File.open(path,"w")
        to_json(file)
        file.close
    end

    def isValid : Bool
        return (@port != "" && @name != "" && @version != "") && File.exists?(filePath)
    end

    def getEnabledPass : String
        @options.each do |option|
            if option.isPass && option.active
                return option.name
            end
        end

        return String.new
    end

    def getEnabledPassNumber : Int32
        stringNumber = getEnabledPass
        return stringNumber == "" ? 0 : stringNumber.gsub("Pass","").to_i
    end

    def hiddenName : String
        passName = getEnabledPass
        return "@#{@port}:#{versionName}#{passName == "" ? "" : "-#{passName}"}"
    end

    def fullName : String
        return "@#{@port}:#{@name}"
    end

    def versionName : String
        return "#{@name}-#{@version}"
    end

    def fullVersionName : String
        return "#{fullName}-#{@version}"
    end

    def builtSoftwareDirectoryPath
        return "#{ISM::Default::Path::BuiltSoftwaresDirectory}#{@port}/#{@name}/#{@version}/"
    end

    def mainDirectoryPath : String
        return Ism.settings.rootPath +
               ISM::Default::Path::SoftwaresDirectory +
               @port + "/" +
               @name + "/" +
               @version + "/"
    end

    def filePath : String
        return mainDirectoryPath + ISM::Default::Filename::Information
    end

    def requireFilePath : String
        return mainDirectoryPath + @version + ".cr"
    end

    def settingsFilePath : String
        return  Ism.settings.rootPath +
                ISM::Default::Path::SettingsSoftwaresDirectory +
                @port + "/" +
                @name + "/" +
                @version + "/" +
                ISM::Default::Filename::SoftwareSettings
    end

    def installedDirectoryPath : String
        return Ism.settings.rootPath +
               ISM::Default::Path::InstalledSoftwaresDirectory +
               @port + "/" +
               @name + "/"
    end

    def installedFilePath : String
        return Ism.settings.rootPath +
               ISM::Default::Path::InstalledSoftwaresDirectory +
               @port + "/" +
               @name + "/" +
               @version + "/" +
               ISM::Default::Filename::Information
    end

    def optionExist(optionName : String) : Bool
        @options.each do |option|
            if optionName == option.name
                return true
            end
        end

        return false
    end

    def option(optionName : String) : Bool
        @options.each do |option|
            if optionName == option.name
                return option.active
            end
        end

        return false
    end

    def enableOption(optionName : String)
        @options.each_with_index do |option, index|
            if optionName == option.name

                #Disable other passes if we are enabling a pass
                if option.isPass
                    currentEnabledPass = getEnabledPass

                    if passEnabled && currentEnabledPass != optionName
                        disableOption(currentEnabledPass)
                    end

                end

                @options[index].active = true

                #Check if the requested option is suppose to be unique
                @uniqueOptions.each do |uniqueArray|
                    if uniqueArray.includes?(optionName)
                        uniqueArray.each do |option|
                            if option != optionName
                                disableOption(option)
                            end
                        end
                    end
                end
            end
        end
    end

    def disableOption(optionName : String)
        @options.each_with_index do |option, index|
            if optionName == option.name
                @options[index].active = false
            end
        end
    end

    def passEnabled : Bool
        @options.each do |option|
            if option.isPass && option.active
                return true
            end
        end

        return false
    end

    def dependencies(allowDeepSearch = false, unsorted = false) : Array(ISM::SoftwareDependency)
        if unsorted
            return @dependencies
        end

        dependenciesArray = Array(ISM::SoftwareDependency).new

        #CHECK IF THERE IS ANY UNIQUE DEPENDENCIES NOT SELECTIONED
        missingSelectedDependencies = getMissingSelectedDependencies

        if missingSelectedDependencies.empty?
            @options.each do |option|

                if passEnabled
                    if option.active
                        if option.isPass
                            return option.dependencies(allowDeepSearch)
                        else
                            dependenciesArray += option.dependencies(allowDeepSearch)
                        end
                    end
                else
                    if option.active || option.isPass
                        dependenciesArray += option.dependencies(allowDeepSearch)
                    end

                    if !option.active && option.isPass
                        requiredPassDependency = self.toSoftwareDependency
                        requiredPassDependency.options.push(option.name)
                        dependenciesArray.push(requiredPassDependency)
                    end
                end

            end
        else
            Ism.showCalculationDoneMessage
            Ism.showMissingSelectedDependenciesMessage(fullName, @version, missingSelectedDependencies)
            Ism.exitProgram
        end

        if allowDeepSearch
            return @dependencies.reject {|entry| dependencyIsUnique(entry.fullName) && !uniqueDependencyIsEnabled(entry.fullName)} + dependenciesArray
        else
            #REJECT INSTALLED DEPENDENCIES AND UNIQUE DEPENDENCIES NOT SELECTIONED
            return @dependencies.reject {|entry| Ism.softwareIsInstalled(entry.information) || dependencyIsUnique(entry.fullName) && !uniqueDependencyIsEnabled(entry.fullName)}+dependenciesArray
        end
    end

    def kernelDependencies : Array(String)
        dependenciesArray = Array(String).new

        @options.each do |option|

            if option.active
                dependenciesArray += option.kernelDependencies
            end

        end

        return @kernelDependencies+dependenciesArray
    end

    def archiveName : String
        return archiveBaseName+archiveExtensionName
    end

    def archiveMd5sumName : String
        return archiveName+archiveMd5sumExtensionName
    end

    def archiveBaseName : String
        return versionName
    end

    def archiveExtensionName : String
        return ISM::Default::SoftwareInformation::ArchiveExtensionName
    end

    def archiveMd5sumExtensionName : String
        return ISM::Default::SoftwareInformation::ArchiveMd5sumExtensionName
    end

    def sourcesLink : String
        return Ism.mirrorsSettings.sourcesLink+archiveName
    end

    def sourcesMd5sumLink : String
        return Ism.mirrorsSettings.sourcesLink+archiveMd5sumName
    end

    def toSoftwareDependency : ISM::SoftwareDependency
        softwareDependency = ISM::SoftwareDependency.new

        softwareDependency.port = @port
        softwareDependency.name = @name
        softwareDependency.version = @version

        @options.each do |option|
            if option.active
                softwareDependency.options << option.name
            end
        end

        return softwareDependency
    end

    def == (other : ISM::SoftwareInformation) : Bool
        return @name == other.name &&
            @version == other.version &&
            @options == other.options
    end

    def dependencyIsUnique(dependency : String) : Bool
        return @uniqueDependencies.map {|entry| entry.includes?(dependency)}.includes?(true)
    end

    def getMissingSelectedDependencies : Array(Array(String))
        result = Array(Array(String)).new

        @uniqueDependencies.each do |uniqueGroup|

            selected = false

            @selectedDependencies.each do |selection|
                if uniqueGroup.any? { |item| item.downcase == selection.downcase}
                    selected = true
                end
            end

            if !selected
                result.push(uniqueGroup)
            end
        end

        return result
    end

    def selectUniqueDependency(dependency : String) : Bool
        selected = false

        @uniqueDependencies.each do |uniqueGroup|
            if !selected
                if uniqueGroup.any? { |item| item.downcase == dependency.downcase}
                    selected = true
                end
            end

            if selected
                #REMOVE OTHER SELECTION
                uniqueGroup.each do |item|
                    if item.downcase != dependency.downcase
                        @selectedDependencies.delete(item)
                    end
                end

                #ADD SELECTION IF NOT PRESENT
                @selectedDependencies = (@selectedDependencies | [dependency])
                break
            end
        end

        return selected
    end

    def uniqueDependencyIsEnabled(dependency : String) : Bool
        return @selectedDependencies.any? { |item| item.downcase == dependency.downcase}
    end

  end

end
