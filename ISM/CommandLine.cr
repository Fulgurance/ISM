module ISM

    class CommandLine

        property systemInformation : ISM::CommandLineSystemInformation
        property requestedSoftwares : Array(ISM::SoftwareInformation)
        property neededKernelOptions : Array(ISM::NeededKernelOption)
        property options : Array(ISM::CommandLineOption)
        property settings : ISM::CommandLineSettings
        property components : Array(ISM::SoftwareInformation)
        property kernels : Array(ISM::AvailableKernel)
        property softwares : Array(ISM::AvailableSoftware)
        property installedSoftwares : Array(ISM::SoftwareInformation)
        property ports : Array(ISM::Port)
        property portsSettings : ISM::CommandLinePortsSettings
        property mirrors : Array(ISM::Mirror)
        property mirrorsSettings : ISM::CommandLineMirrorsSettings
        property favouriteGroups : Array(ISM::FavouriteGroup)
        property totalInstalledDirectoryNumber : UInt128
        property totalInstalledSymlinkNumber : UInt128
        property totalInstalledFileNumber : UInt128
        property totalInstalledSize : UInt128

        def initialize
            @systemInformation = ISM::CommandLineSystemInformation.new
            @requestedSoftwares = Array(ISM::SoftwareInformation).new
            @neededKernelOptions = Array(ISM::NeededKernelOption).new
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false
            @text = ISM::Default::CommandLine::CalculationWaitingText
            @options = ISM::Default::CommandLine::Options
            @settings = ISM::CommandLineSettings.new
            @components = Array(ISM::SoftwareInformation).new
            @kernels = Array(ISM::AvailableKernel).new
            @softwares = Array(ISM::AvailableSoftware).new
            @installedSoftwares = Array(ISM::SoftwareInformation).new
            @ports = Array(ISM::Port).new
            @portsSettings = ISM::CommandLinePortsSettings.new
            @mirrors = Array(ISM::Mirror).new
            @mirrorsSettings = ISM::CommandLineMirrorsSettings.new
            @favouriteGroups = Array(ISM::FavouriteGroup).new
            @initialTerminalTitle = String.new
            @unavailableDependencySignals = Array(Array(ISM::SoftwareInformation)).new
            @totalInstalledDirectoryNumber = UInt128.new(0)
            @totalInstalledSymlinkNumber = UInt128.new(0)
            @totalInstalledFileNumber = UInt128.new(0)
            @totalInstalledSize = UInt128.new(0)
            @increasingPhase = true
            @colorPhase = 0
            @red = UInt8.new(55)
            @blue = UInt8.new(55)
            @green = UInt8.new(55)
        end

        def ranAsSuperUser : Bool
            return (LibC.getuid == 0)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "ranAsSuperUser",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def ranAsMemberOfIsmGroup : Bool
            processResult = IO::Memory.new

            Process.run(    command: "id -G",
                            output: processResult,
                            shell: true)

            return processResult.to_s.strip.split(" ").includes?(ISM::Default::Core::Security::SystemId)

            rescue exception
            ISM::Error.show(className: "Core::Security",
                            functionName: "ranAsMemberOfGroupIsm",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end

        def start
            loadSettingsFiles
            loadSystemInformationFile
            loadKernelOptionDatabase
            loadNeededKernelOptions
            loadSoftwareDatabase
            loadInstalledSoftwareDatabase
            loadPortsDatabase
            loadMirrorsDatabase
            loadFavouriteGroupsDatabase
            checkEnteredArguments

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "start",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadNeededKernelOptions
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::NeededKernelOptionsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::NeededKernelOptionsDirectory)
            end

            neededKernelOptions = Dir.children(@settings.rootPath+ISM::Default::Path::NeededKernelOptionsDirectory)

            neededKernelOptions.each do |option|

                @neededKernelOptions << ISM::NeededKernelOption.loadConfiguration(@settings.rootPath+ISM::Default::Path::NeededKernelOptionsDirectory+"/"+option)

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadNeededKernelOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadKernelOptionDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::KernelOptionsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::KernelOptionsDirectory)
            end

            availableKernels = Dir.children(@settings.rootPath+ISM::Default::Path::KernelOptionsDirectory)

            availableKernels.each do |kernelDirectory|

                kernelOptionFiles = Dir.children(@settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+"/"+kernelDirectory)

                availableKernel = ISM::AvailableKernel.new(kernelDirectory)

                kernelOptionFiles.each do |kernelOptionFile|
                    availableKernel.options << ISM::KernelOption.loadConfiguration(@settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+"/"+kernelDirectory+"/"+kernelOptionFile)
                end

                @kernels << availableKernel

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadKernelOptionDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadSoftware(port : String, name : String, version : String) : ISM::SoftwareInformation
            software = ISM::SoftwareInformation.loadConfiguration(  @settings.rootPath +
                                                                    ISM::Default::Path::SoftwaresDirectory +
                                                                    port + "/" +
                                                                    name + "/" +
                                                                    version + "/" +
                                                                    ISM::Default::Filename::Information)

            if File.exists?(@settings.rootPath +
                            ISM::Default::Path::SettingsSoftwaresDirectory +
                            port + "/" +
                            name + "/" +
                            version + "/" +
                            ISM::Default::Filename::SoftwareSettings)

                softwareSettings = ISM::SoftwareInformation.loadConfiguration(  @settings.rootPath +
                                                                                ISM::Default::Path::SettingsSoftwaresDirectory +
                                                                                port + "/" +
                                                                                name + "/" +
                                                                                version + "/" +
                                                                                ISM::Default::Filename::SoftwareSettings)

                softwareSettings.options.each do |option|

                    if software.optionExist(option.name)
                        case option.active
                        when true
                            software.enableOption(option.name)
                        when false
                            software.disableOption(option.name)
                        end
                    end

                end

                software.uniqueDependencies = softwareSettings.uniqueDependencies
                software.uniqueOptions = softwareSettings.uniqueOptions
                software.selectedDependencies = softwareSettings.selectedDependencies

            end

            return software

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadSoftwareDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::SoftwaresDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::SoftwaresDirectory)
            end

            portDirectories = Dir.children(@settings.rootPath+ISM::Default::Path::SoftwaresDirectory)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children(@settings.rootPath+ISM::Default::Path::SoftwaresDirectory+portDirectory).reject!(&.starts_with?(".git"))

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children(  @settings.rootPath +
                                                        ISM::Default::Path::SoftwaresDirectory+portDirectory + "/" +
                                                        softwareDirectory)
                    softwaresInformations = Array(ISM::SoftwareInformation).new

                    versionDirectories.each do |versionDirectory|

                        loadedSoftware = loadSoftware(portDirectory,softwareDirectory,versionDirectory)
                        softwaresInformations << loadedSoftware

                        if loadedSoftware.type == "ComponentSoftware"
                            @components << loadedSoftware
                        end

                    end

                    @softwares << ISM::AvailableSoftware.new(portDirectory, softwareDirectory, softwaresInformations)

                end

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadSoftwareDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadPortsDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::PortsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::PortsDirectory)
            end

            portsFiles = Dir.children(@settings.rootPath+ISM::Default::Path::PortsDirectory)

            portsFiles.each do |portFile|
                path = ISM::Port.filePath(portFile[0..-6])
                @ports << ISM::Port.loadConfiguration(path)
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadPortsDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadMirrorsDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::MirrorsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::MirrorsDirectory)
            end

            mirrorsFiles = Dir.children(@settings.rootPath+ISM::Default::Path::MirrorsDirectory)

            if mirrorsFiles.size == 0
                @mirrors << ISM::Mirror.loadConfiguration
            else
                mirrorsFiles.each do |mirrorFile|
                    path = ISM::Mirror.filePath(mirrorFile[0..-6])
                    @mirrors << ISM::Mirror.loadConfiguration(path)
                end
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadMirrorsDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadFavouriteGroupsDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)
            end

            favouriteGroupsFiles = Dir.children(@settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)

            if favouriteGroupsFiles.size == 0
                @favouriteGroups << ISM::FavouriteGroup.loadConfiguration
            else
                favouriteGroupsFiles.each do |favouriteGroupFile|
                    path = ISM::FavouriteGroup.filePath(favouriteGroupFile[0..-6])
                    @favouriteGroups << ISM::FavouriteGroup.loadConfiguration(path)
                end
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadFavouriteGroupsDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadSystemInformationFile
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::SettingsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::SettingsDirectory)
            end

            @systemInformation = ISM::CommandLineSystemInformation.loadConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadSystemInformationFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadSettingsFiles
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::SettingsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::SettingsDirectory)
            end

            @settings = ISM::CommandLineSettings.loadConfiguration
            @portsSettings = ISM::CommandLinePortsSettings.loadConfiguration
            @mirrorsSettings = ISM::CommandLineMirrorsSettings.loadConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadSettingsFiles",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadInstalledSoftware(port : String, name : String, version : String) : ISM::SoftwareInformation
            begin
                return ISM::SoftwareInformation.loadConfiguration(  @settings.rootPath +
                                                                    ISM::Default::Path::InstalledSoftwaresDirectory +
                                                                    port + "/" +
                                                                    name + "/" +
                                                                    version + "/" +
                                                                    ISM::Default::Filename::Information)
            rescue
                return ISM::SoftwareInformation.new
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadInstalledSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadInstalledSoftwareDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory)
            end

            portDirectories = Dir.children(@settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children(@settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory+portDirectory)

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children(  @settings.rootPath +
                                                        ISM::Default::Path::InstalledSoftwaresDirectory+portDirectory + "/" +
                                                        softwareDirectory)

                    versionDirectories.each do |versionDirectory|

                        @installedSoftwares << loadInstalledSoftware(portDirectory, softwareDirectory, versionDirectory)

                    end

                end

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadInstalledSoftwareDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def selectedKernel : ISM::SoftwareInformation
            if File.exists?("#{Ism.settings.rootPath}#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::SelectedKernel}")
                return ISM::SoftwareInformation.loadConfiguration("#{Ism.settings.rootPath}#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::SelectedKernel}")
            else
                return ISM::SoftwareInformation.new
            end

            rescue error
                printSystemCallErrorNotification(error)
                exitProgram
        end

        def kernelIsSelected
            return selectedKernel.isValid

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "selectedKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def inputMatchWithFilter(input : String, filter : Regex | Array(Regex))
            if filter.is_a?(Array(Regex))
                userInput = input.split(" ")

                userInput.each do |value|

                    if !filter.any? {|rule| rule.matches?(value)}
                        return false,value
                    end

                end
            else
                if !filter.matches?(input)
                    return false,input
                end
            end

            return true,String.new

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "inputMatchWithFilter",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def reportMissingDependency(missingDependency : ISM::SoftwareInformation, relatedSoftware : ISM::SoftwareInformation)
            @unavailableDependencySignals.push([relatedSoftware, missingDependency])

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "reportMissingDependency",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def addInstalledSoftware(softwareInformation : ISM::SoftwareInformation, installedFiles = Array(String).new)
            softwareInformation.installedFiles = installedFiles
            softwareInformation.writeConfiguration(softwareInformation.installedFilePath)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "addInstalledSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def addSoftwareToFavouriteGroup(fullVersionName : String, favouriteGroupName = ISM::Default::FavouriteGroup::Name)
            path = ISM::FavouriteGroup.filePath(favouriteGroupName)

            favouriteGroup = ISM::FavouriteGroup.loadConfiguration(path)
            favouriteGroup.softwares = favouriteGroup.softwares | [fullVersionName]
            favouriteGroup.writeConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "addSoftwareToFavouriteGroup",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def removeSoftwareToFavouriteGroup(fullVersionName : String, favouriteGroupName = ISM::Default::FavouriteGroup::Name)
            path = ISM::FavouriteGroup.filePath(favouriteGroupName)

            if File.exists?(path)
                favouriteGroup = ISM::FavouriteGroup.loadConfiguration(path)
                favouriteGroup.softwares.delete(fullVersionName)
                favouriteGroup.writeConfiguration
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "removeSoftwareToFavouriteGroup",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def uninstallSoftware(software : ISM::SoftwareInformation)

            requestedVersion = ISM::SoftwareInformation.new
            otherVersions = Array(ISM::SoftwareInformation).new
            protectedFiles = Array(String).new
            filesForRemoval = Array(String).new
            softwareForRemovalIndex = 0

            @installedSoftwares.each_with_index do |installedSoftware, index|
                if software.hiddenName == installedSoftware.hiddenName
                    requestedVersion = installedSoftware
                    softwareForRemovalIndex = index
                else
                    if software.fullName == installedSoftware.fullName
                        otherVersions.push(installedSoftware)
                    end
                end
            end

            if requestedVersion.isValid
                protectedFiles = otherVersions.map {|version| version.installedFiles }.flatten.uniq

                if protectedFiles.size > 0
                    protectedFiles.each do |file|

                        if !requestedVersion.installedFiles.includes?(file)
                            filesForRemoval.push(file)
                        end
                    end
                else
                    filesForRemoval = requestedVersion.installedFiles
                end

                filesForRemoval.each do |file|
                    if File.exists?(file)
                        FileUtils.rm_r(file)
                    end
                end

                FileUtils.rm_r(software.installedDirectoryPath+"/"+software.version)

                if Dir.empty?(software.installedDirectoryPath)
                    FileUtils.rm_r(software.installedDirectoryPath)
                end

                #Update the ISM instance to make sure the database is up to date and avoiding to reload everything
                @installedSoftwares.delete(softwareForRemovalIndex)
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "uninstallSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareAnyVersionInstalled(fullName : String) : Bool

            @installedSoftwares.each do |installedSoftware|

                if fullName == installedSoftware.fullName && !installedSoftware.passEnabled
                    return true
                end

            end

            return false

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "softwareAnyVersionInstalled",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareIsRequestedSoftware(software : ISM::SoftwareInformation, requestedSoftwareVersionNames = Array(String).new) : Bool
            if requestedSoftwareVersionNames.empty?
                return @requestedSoftwares.any? { |entry| entry.fullVersionName == software.fullVersionName}
            else
                return requestedSoftwareVersionNames.any? { |entry| entry == software.fullVersionName}
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "softwareIsRequestedSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareIsInstalled(software : ISM::SoftwareInformation) : Bool

            installedOne = ISM::SoftwareInformation.new

            if File.exists?(software.installedFilePath)
                installedOne = ISM::SoftwareInformation.loadConfiguration(software.installedFilePath)
            end

            alreadyInstalled = installedOne.isValid

            if !alreadyInstalled && !software.passEnabled || !alreadyInstalled && software.passEnabled && !@systemInformation.crossToolchainFullyBuilt
                return false
            else

                installedOneOptions = installedOne.options.map { |entry| entry.active ? entry.name : "" }.reject { |entry| entry.empty? }.sort
                softwareOptions = software.options.map { |entry| entry.active ? entry.name : "" }.reject { |entry| entry.empty? }.sort

                #Case when requested software have an enabled pass
                if software.passEnabled

                    #If the installed one don't have enabled pass, that mean the software is already fully installed
                    #Case when the cross toolchain is already fully built: no need to build any pass
                    if !installedOne.passEnabled || @systemInformation.crossToolchainFullyBuilt
                        return true
                    else
                    #If not, we need to compare the pass numbers

                        installedOnePassNumber = installedOne.getEnabledPassNumber
                        softwarePassNumber = software.getEnabledPassNumber

                        #If the requested one have a lower number or equal, that mean the software is already installed
                        return softwarePassNumber <= installedOnePassNumber ? true : false
                    end

                else
                #Case when requested software don't have enabled pass

                    #If the installed one have an enabled pass, the requested software is not installed
                    if installedOne.passEnabled
                        return false
                    else
                    #If both don't have enabled pass, then we need to check both options to state what to do

                        optionAlreadyInstalled = (installedOneOptions & softwareOptions == softwareOptions)

                        #If the installed one have already the requested options or more, that mean it's already installed
                        if optionAlreadyInstalled
                            return true
                        else
                            return false
                        end

                    end

                end

            end

            #Just in case something go wrong
            return false

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "softwareIsInstalled",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwaresAreCodependent(software1 : ISM::SoftwareInformation, software2 : ISM::SoftwareInformation) : Bool
            return software1.allowCodependencies.includes?(software2.fullName) && software2.allowCodependencies.includes?(software1.fullName) && !software1.passEnabled && !software2.passEnabled

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "softwaresAreCodependent",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getSoftwareStatus(software : ISM::SoftwareInformation) : Symbol
            installedSoftware = loadInstalledSoftware(software.port,software.name,software.version)

            if !softwareIsInstalled(software)

                #Pass case
                if software.passEnabled
                    return :buildingPhase
                end

                #Additional version case
                if software.version < installedSoftware.version
                    :additionalVersion
                end

                #Update case
                if software.version > installedSoftware.version && installedSoftware.isValid
                    return :update
                end

                #Option updates case
                if software.version == installedSoftware.version && software.options != installedSoftware.options && installedSoftware.isValid && !software.passEnabled && !installedSoftware.passEnabled
                    return :optionUpdate
                end

                #None of above case: new one
                return :new
            else

                #Rebuild case
                return :rebuild
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getSoftwareStatus",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getAvailableSoftware(userEntry : String) : ISM::AvailableSoftware
            @softwares.each do |software|
                if userEntry.downcase.includes?(software.fullName.downcase) && userEntry.size == software.fullName.size
                    return software
                else
                    software.versions.each do |version|
                        if userEntry.downcase == version.fullName.downcase || userEntry.downcase == version.fullVersionName.downcase
                            return software
                        end
                    end
                end
            end

            return ISM::AvailableSoftware.new

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getAvailableSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Add process to search only by name
        def getSoftwareInformation(userEntry : String, allowSearchByNameOnly = false) : ISM::SoftwareInformation

            entry = String.new
            matches = Array(String).new
            result = ISM::SoftwareInformation.new

            if allowSearchByNameOnly

                #Check first if the user entry if by name only or not, and if it is valid
                @softwares.each do |availableSoftware|

                    #Check if the user request a specific version or not
                    if availableSoftware.name.downcase == userEntry.downcase
                        matches.push(availableSoftware.fullName)
                    else
                        availableSoftware.versions.each do |software|
                            if software.versionName.downcase == userEntry.downcase
                                matches.push(software.fullVersionName)
                            end
                        end
                    end
                end

                #There are more than one match, the user need to specify a port (Ambiguous)
                if matches.size > 1
                    showAmbiguousSearchMessage(matches)
                    exitProgram
                end

                #If there is only one match, it mean the user enter by name only, we record the fullName
                if !matches.empty? && matches.size == 1
                    entry = matches[0]
                end
            end

            if entry == ""
                entry = userEntry
            end

            availableSoftware = getAvailableSoftware(entry)
            versions = availableSoftware.versions

            if !versions.empty?

                versions.each do |software|
                    if software.fullVersionName.downcase == entry.downcase

                        result = loadSoftware(software.port, software.name, software.version)

                        break
                    end
                end

                if !result.isValid
                    return availableSoftware.greatestVersion
                end
            end

            #No match found
            return result

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getSoftwareInformation",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def checkEnteredArguments
            matchingOption = false

            terminalTitleArguments = (ARGV.empty? ? "" : ARGV.join(" "))
            setTerminalTitle("#{ISM::Default::CommandLine::Name} #{terminalTitleArguments}")

            if ARGV.empty?
                matchingOption = true
                @options[0].start
                resetTerminalTitle
            else
                @options.each_with_index do |argument, index|

                    if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                        matchingOption = true
                        @options[index].start
                        resetTerminalTitle
                        break
                    end

                end
            end

            if !matchingOption
                showErrorUnknowArgument
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "checkEnteredArguments",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def printRanAsSuperUserErrorNotification
            puts "#{ISM::Default::CommandLine::RanAsSuperUserText.colorize(:yellow)}"
        end

        def printNotRanAsMemberOfIsmGroupErrorNotification
            puts "#{ISM::Default::CommandLine::NotRanAsMemberOfIsmGroupText.colorize(:yellow)}"
        end

        def showErrorUnknowArgument
            puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
            puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
        end

        def printProcessNotification(message : String)
            puts "#{ISM::Default::CommandLine::ProcessNotificationCharacters.colorize(:green)} #{message}"
        end

        def printSubProcessNotification(message : String)
            puts "\t#{"|".colorize(:green)} #{message}"
        end

        def printErrorNotification(message : String, error)
            puts
            puts "[#{"!".colorize(:red)}] #{message.colorize(Colorize::ColorRGB.new(255,100,100))}"

            if typeof(error) == Exception
                puts "[#{"!".colorize(:red)}] "
                puts "#{error.colorize(Colorize::ColorRGB.new(255,100,100))}"
            end
        end

        def printInternalErrorNotification(error : ISM::TaskBuildingProcessError)
            limit = ISM::Default::CommandLine::InternalErrorTitle.size

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "="
            end

            title = "#{ISM::Default::CommandLine::InternalErrorTitle.colorize(:red)}"
            separatorText = "#{separatorText.colorize(:red)}"
            errorText = "\n#{ISM::Default::CommandLine::TaskBuildingProcessErrorText1}#{error.file}#{ISM::Default::CommandLine::TaskBuildingProcessErrorText2}#{error.line.to_s}\n#{error.message}".colorize(Colorize::ColorRGB.new(255,100,100))
            help = "\n#{ISM::Default::CommandLine::TaskBuildingErrorNotificationHelp.colorize(:red)}"

            puts
            puts separatorText
            puts title
            puts separatorText
            puts errorText
            puts help
        end

        def printInstallerImplementationErrorNotification(software : ISM::SoftwareInformation, error : ISM::TaskBuildingProcessError)
            limit = ISM::Default::CommandLine::InstallerImplementationErrorTitle.size
            errorText1 = "#{ISM::Default::CommandLine::InstallerImplementationErrorText1.colorize(Colorize::ColorRGB.new(255,100,100))}"
            softwareText = "#{"@#{software.port}".colorize(:red)}:#{software.name.colorize(:green)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/"
            errorText2 = "#{ISM::Default::CommandLine::InstallerImplementationErrorText2}#{error.line.to_s}:".colorize(Colorize::ColorRGB.new(255,100,100))
            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "="
            end

            title = "#{ISM::Default::CommandLine::InstallerImplementationErrorTitle.colorize(:red)}"
            separatorText = "#{separatorText.colorize(:red)}"
            errorText = "\n#{errorText1}#{softwareText}#{errorText2}\n\n#{error.message.colorize(:yellow)}"
            help = "\n#{ISM::Default::CommandLine::InstallerImplementationErrorNotificationHelp.colorize(:red)}"

            puts
            puts separatorText
            puts title
            puts separatorText
            puts errorText
            puts help
        end

        def notifyOfGetFileContentError(filePath : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorGetFileContentText+filePath, error)
        end

        def printSystemCallErrorNotification(error : Exception)
            limit = ISM::Default::CommandLine::InternalErrorTitle.size

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "="
            end

            fullLog = (error.backtrace? ? error.backtrace.join("\n") : error.message)

            title = "#{ISM::Default::CommandLine::InternalErrorTitle.colorize(:red)}"
            separatorText = "#{separatorText.colorize(:red)}"
            errorText = "\n#{fullLog.colorize(Colorize::ColorRGB.new(255,100,100))}"
            help = "\n#{ISM::Default::CommandLine::SystemCallErrorNotificationHelp.colorize(:red)}"

            puts
            puts separatorText
            puts title
            puts separatorText
            puts errorText
            puts help
        end

        def printInformationNotificationTitle(name : String, version : String)
            limit = name.size+version.size+2
            text = "#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/"

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "-"
            end

            separatorText = "#{separatorText.colorize(:green)}"

            puts
            puts separatorText
            puts text
            puts separatorText
        end

        def printInformationNotification(message : String)
            puts "[#{"Info".colorize(:green)}] #{message}"
        end

        def printInformationCodeNotification(message : String)
            puts "#{message.colorize(:magenta).back(Colorize::ColorRGB.new(80, 80, 80))}"
        end

        def notifyOfDownload(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::DownloadText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfDownloadAdditions
            printProcessNotification(ISM::Default::CommandLine::DownloadAdditionsText)
        end

        def notifyOfCheck(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::CheckText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfCheckAdditions
            printProcessNotification(ISM::Default::CommandLine::CheckAdditionsText)
        end

        def notifyOfExtract(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::ExtractText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfExtractAdditions
            printProcessNotification(ISM::Default::CommandLine::ExtractAdditionsText)
        end

        def notifyOfPatch(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::PatchText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfLocalPatch(patchName : String)
            printSubProcessNotification(ISM::Default::CommandLine::LocalPatchText+"#{patchName.colorize(:yellow)}")
        end

        def notifyOfPrepare(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::PrepareText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfConfigure(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::ConfigureText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfBuild(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::BuildText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfPrepareInstallation(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::PrepareInstallationText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfDeploy
            printSubProcessNotification(ISM::Default::CommandLine::DeployText)
        end

        def notifyOfUpdateSystemCache
            printSubProcessNotification(ISM::Default::CommandLine::UpdateSystemCacheText)
        end

        def notifyOfInstall(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::InstallText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfUpdateKernelOptionsDatabase(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::UpdateKernelOptionsDatabaseText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfRecordNeededKernelOptions
            kernelName = (selectedKernel.name == "" ? ISM::Default::CommandLine::FuturKernelText : selectedKernel.name )

            printProcessNotification(ISM::Default::CommandLine::RecordNeededKernelOptionsText+"#{kernelName.colorize(:green)}")
        end

        def notifyOfClean(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::CleanText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfUninstall(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::UninstallText+"#{softwareInformation.name.colorize(:green)}")
        end

        def notifyOfDownloadError(link : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorDownloadText+link, error)
        end

        def notifyOfConnexionError(link : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorConnexionText1 +
                                    link +
                                    ISM::Default::CommandLine::ErrorConnexionText2,
                                    error)
        end

        def notifyOfCheckError(archive : String, sha512 : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorCheckText1 +
                                    archive +
                                    ISM::Default::CommandLine::ErrorCheckText2 +
                                    sha512, error)
        end

        def notifyOfExtractError(archivePath : String, destinationPath : String ,error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorExtractText1 +
                                    archivePath +
                                    ISM::Default::CommandLine::ErrorExtractText2 +
                                    destinationPath,
                                    error)
        end

        def notifyOfApplyPatchError(patchName : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorApplyPatchText+patchName, error)
        end

        def notifyOfCopyFileError(path : String | Enumerable(String), targetPath : String, error = nil)
            if path.is_a?(Enumerable(String))
                path = path.join(",")

            end
            printErrorNotification(ISM::Default::CommandLine::ErrorCopyFileText1 +
                                   path +
                                   ISM::Default::CommandLine::ErrorCopyFileText2 +
                                   targetPath, error)
        end

        def notifyOfCopyDirectoryError(path : String, targetPath : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorCopyDirectoryText1 +
                                   path +
                                   ISM::Default::CommandLine::ErrorCopyDirectoryText2 +
                                   targetPath, error)
        end

        def notifyOfDeleteFileError(path : String | Enumerable(String), error = nil)
            if path.is_a?(Enumerable(String))
                path = path.join(",")
            end

            printErrorNotification(ISM::Default::CommandLine::ErrorDeleteFileText+path, error)
        end

        def notifyOfMoveFileError(path : String | Enumerable(String), newPath : String, error = nil)
            if path.is_a?(Enumerable(String))
                path = path.join(",")
            end

            printErrorNotification( ISM::Default::CommandLine::ErrorMoveFileText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMoveFileText2 +
                                    newPath, error)
        end

        def notifyOfMakeDirectoryError(directory : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorMakeDirectoryText+directory, error)
        end

        def notifyOfDeleteDirectoryError(directory : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorDeleteDirectoryText+directory, error)
        end

        def notifyOfMakeLinkUnknowTypeError(path : String, targetPath : String, linkType : Symbol, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText2 +
                                    targetPath +
                                    ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText3 +
                                    linkType.to_s, error)
        end

        def notifyOfRunSystemCommandError(arguments : String, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, error = nil)

            argumentText = "#{ISM::Default::CommandLine::ErrorRunSystemCommandText1}#{arguments.squeeze(" ")}"
            pathText = String.new
            environmentText = String.new
            environmentFilePathText = String.new

            if !path.empty?
                pathText = "#{ISM::Default::CommandLine::ErrorRunSystemCommandText2}#{(@systemInformation.handleChroot ? @settings.rootPath : "")}#{path}".squeeze("/")
            end

            if !environment.empty?
                environmentText = "#{ISM::Default::CommandLine::ErrorRunSystemCommandText3}#{(environment.map { |key| key.join("=") }).join(" ")}"
            end

            if !environmentFilePath.empty?
                environmentFilePathText = "#{ISM::Default::CommandLine::ErrorRunSystemCommandText4}#{environmentFilePath}"
            end

            printErrorNotification( "#{argumentText}#{pathText}#{environmentText}#{environmentFilePathText}",
                                        error)
        end

        def notifyOfUpdateKernelOptionsDatabaseError(software : ISM::SoftwareInformation, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorUpdateKernelOptionsDatabaseText+software.versionName, error)
        end

        def resetCalculationAnimation
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false

            rescue error
                printSystemCallErrorNotification(error)
                exitProgram
        end

        def playCalculationAnimation(@text = ISM::Default::CommandLine::CalculationWaitingText)
            currentTime = Time.monotonic

            if (currentTime - @calculationStartingTime).milliseconds > 40

                #Limits
                minimumValue = 55
                maximumValue = 255
                speed = 10

                if @increasingPhase && @red >= maximumValue && @blue >= maximumValue && @green >= maximumValue
                    @increasingPhase = false
                end

                if !@increasingPhase && @red <= minimumValue && @blue <= minimumValue && @green <= minimumValue
                    @increasingPhase = true
                end

                case @colorPhase
                when 0
                    @increasingPhase ? (@red += speed) : (@red -= speed)

                    if @increasingPhase && @red >= maximumValue || !@increasingPhase && @red <= minimumValue
                        @colorPhase += 1
                    end
                when 1
                    @increasingPhase ? (@blue += speed) : (@blue -= speed)

                    if @increasingPhase && @blue >= maximumValue || !@increasingPhase && @blue <= minimumValue
                        @colorPhase += 1
                    end
                when 2
                    @increasingPhase ? (@green += speed) : (@green -= speed)

                    if @increasingPhase && @green >= maximumValue || !@increasingPhase && @green <= minimumValue
                        @colorPhase = 0
                    end
                end

                color = Colorize::ColorRGB.new(@red,@blue,@green)

                if !@reverseAnimation && @frameIndex == 0
                    print "#{@text.colorize(:dark_gray)}"
                    (0..(@text.size-1)).each do |index|
                        print "\033[1D"
                    end
                end

                if @frameIndex > @text.size-1
                    @reverseAnimation = true
                    @frameIndex = @text.size-1

                    (0..(@text.size-1)).each do |index|
                        print "\033[1D"
                    end

                    print "#{@text.colorize(:dark_gray)}"
                end

                if @reverseAnimation && @frameIndex >= 0

                    print "\b "
                    print "\033[1D"
                    print "\b#{@text[@frameIndex-1].colorize(color)}"

                    @frameIndex -= 1

                    if @frameIndex < 0
                        @reverseAnimation = false
                        @frameIndex = 0
                        print "#{@text.colorize(:dark_gray)}"
                        (0..(@text.size-1)).each do |index|
                            print "\033[1D"
                        end
                    end

                end

                if !@reverseAnimation && @frameIndex <= @text.size-1

                    @frameIndex += 1

                    print "\b "
                    print "#{@text[@frameIndex-1].colorize(color)}"

                end

                @calculationStartingTime = Time.monotonic
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "playCalculationAnimation",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def cleanCalculationAnimation
            loop do
                if @frameIndex > 0 || @reverseAnimation && @frameIndex >= 0
                    print "\033[1D"
                    print " "
                    print "\033[1D"
                    @frameIndex -= 1
                else
                    break
                end
            end

            (0..@text.size-1).each do |index|
                print " "
            end

            (0..(@text.size-1)).each do |index|
                print "\033[1D"
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "cleanCalculationAnimation",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getRequestedSoftwares(list : Array(String), allowSearchByNameOnly = false) : Array(ISM::SoftwareInformation)
            softwaresList = Array(ISM::SoftwareInformation).new

            list.each do |entry|
                software = getSoftwareInformation(entry, allowSearchByNameOnly)

                if software.isValid
                    softwaresList << software
                end
            end

            return softwaresList

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getRequestedSoftwares",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setTerminalTitle(title : String)
            if @initialTerminalTitle == ""
                @initialTerminalTitle= "\e"
            end
            STDOUT << "\e]0; #{title}\e\\"

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "setTerminalTitle",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def resetTerminalTitle
            setTerminalTitle(@initialTerminalTitle)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "resetTerminalTitle",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def exitProgram(code = 0)
            resetTerminalTitle
            exit code
        end

        #TO IMPROVE: Pass the beginning of class generation to check if its class related problem
        def showTaskBuildingProcessErrorMessage(taskError : ISM::TaskBuildingProcessError, taskPath : String)
            targetMarkPointFilter = /^#TARGET[0-9]+#\//
            endTargetSectionMarkPoint = "#END TARGET SECTION"

            taskCodeLines = File.read_lines(taskPath)

            targetStartingLine = 0
            realLineNumber = 0
            targetPath = String.new
            software = ISM::SoftwareInformation.new

            codeLines = taskCodeLines[0..taskError.line-1]

            #Instead to start from zero, start from passed index to gain performance
            codeLines.reverse_each.with_index do |line, index|

                if line == endTargetSectionMarkPoint
                    break
                end

                if targetMarkPointFilter.matches?(line)
                    targetStartingLine = codeLines.size-index
                    realLineNumber = taskError.line-targetStartingLine
                    targetPath = line[line.index("/")..-1]

                    software = ISM::SoftwareInformation.loadConfiguration(targetPath)
                    break
                end

            end

            #Not related to target installer implementation
            if targetStartingLine == 0
                printInternalErrorNotification(taskError)
            else
            #Related to target installer implementation
                printInstallerImplementationErrorNotification(  software,
                                                                ISM::TaskBuildingProcessError.new(  file:       targetPath,
                                                                                                    line:       realLineNumber,
                                                                                                    column:     taskError.column,
                                                                                                    size:       taskError.size,
                                                                                                    message:    taskError.message))
            end
        end

        def showNoMatchFoundMessage(wrongArguments : Array(String))
            puts ISM::Default::CommandLine::NoMatchFound + "#{wrongArguments.join(", ").colorize(:green)}"
            puts ISM::Default::CommandLine::NoMatchFoundAdvice
            puts
            puts "#{ISM::Default::CommandLine::DoesntExistText.colorize(:green)}"
        end

        def showSoftwareNotInstalledMessage(wrongArguments : Array(String))
            puts ISM::Default::CommandLine::SoftwareNotInstalled + "#{wrongArguments.join(", ").colorize(:green)}"
            puts
            puts "#{ISM::Default::CommandLine::NotInstalledText.colorize(:green)}"
        end

        def showNoVersionAvailableMessage(wrongArguments : Array(String))
            puts ISM::Default::CommandLine::NoVersionAvailable + "#{wrongArguments.join(", ").colorize(:green)}"
            puts ISM::Default::CommandLine::NoVersionAvailableAdvice
            puts
            puts "#{ISM::Default::CommandLine::DoesntExistText.colorize(:green)}"
        end


        def showNoUpdateMessage
            puts "#{ISM::Default::CommandLine::NoUpdate.colorize(:green)}"
        end

        def showNoCleaningRequiredMessage
            puts "#{ISM::Default::CommandLine::NoCleaningRequiredMessage.colorize(:green)}"
        end

        def showSoftwareNeededMessage(wrongArguments : Array(String))
            puts ISM::Default::CommandLine::SoftwareNeeded + "#{wrongArguments.join(", ").colorize(:green)}"
            puts
            puts "#{ISM::Default::CommandLine::NeededText.colorize(:green)}"
        end

        def showSkippedUpdatesMessage
            puts "#{ISM::Default::CommandLine::SkippedUpdatesText.colorize(:yellow)}"
            puts
        end

        def showUnavailableDependencyMessage(software : ISM::SoftwareInformation, dependency : ISM::SoftwareInformation, allowTitle = true)
            puts

            if allowTitle
                puts "#{ISM::Default::CommandLine::UnavailableText1.colorize(:yellow)}"
                puts "\n"
            end

            dependencyText = "#{dependency.fullName.colorize(:magenta)}" + " /" + "#{dependency.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

            optionsText = "{ "

            if dependency.options.empty?
                optionsText += "#{"#{ISM::Default::CommandLine::NoOptionText} ".colorize(:dark_gray)}"
            end

            dependency.options.each do |option|
                if option.active
                    optionsText += "#{option.name.colorize(:red)}"
                else
                    optionsText += "#{option.name.colorize(:blue)}"
                end
                optionsText += " "
            end
            optionsText += "}"

            missingDependencyText = "#{ISM::Default::CommandLine::UnavailableText2.colorize(:red)}"

            softwareText = "#{software.fullName.colorize(:green)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/"

            puts "\t" + dependencyText + optionsText + missingDependencyText + softwareText + "\n"

            if allowTitle
                puts "\n"
            end
        end

        def showAmbiguousSearchMessage(matches : Array(String))
            names = String.new

            puts
            puts "#{ISM::Default::CommandLine::AmbiguousSearchTitle.colorize(:yellow)}"
            puts "\n"

            matches.each_with_index do |name, index|
                names += "#{name.colorize(:red)}#{index < matches.size-1 ? ", " : "."}"
            end

            puts "#{ISM::Default::CommandLine::AmbiguousSearchText.colorize(:green)} #{names}"
        end

        def showInextricableDependenciesMessage(treeArrays : Array(Array(ISM::SoftwareInformation)))
            dependencyChains = Array(Array(ISM::SoftwareInformation)).new

                #TO DO ?
                dependencyChains = treeArrays

                puts
                puts "#{ISM::Default::CommandLine::InextricableText.colorize(:yellow)}"
                puts "\n"

                #Now we print each chains with in highlight the first and last one
                dependencyChains.each do |chain|

                    chain.each_with_index do |software, index|
                        if index == 0
                            color = :green
                        else
                            color = :magenta
                        end

                        softwareText = "#{software.fullName.colorize(color)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/ "
                        optionsText = "{ "

                        if software.options.empty?
                            optionsText += "#{"#{ISM::Default::CommandLine::NoOptionText} ".colorize(:dark_gray)}"
                        end

                        software.options.each do |option|
                            if option.active
                                optionsText += "#{option.name.colorize(:red)}"
                            else
                                optionsText += "#{option.name.colorize(:blue)}"
                            end
                            optionsText += " "
                        end
                        optionsText += "}"

                        puts "\t#{softwareText} #{optionsText}\n"
                    end

                    puts "\n"

                end

                puts "\n"
        end

        def showMissingSelectedDependenciesMessage(fullName : String, version : String, dependencySelection : Array(Array(String)))
            puts "#{ISM::Default::CommandLine::MissingSelectedDependenciesText.colorize(:yellow)}"
            puts "\n"

            puts "#{fullName.colorize(:magenta)}" + " /" + "#{version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

            dependencySelection.each do |selection|
                dependencySet = selection.map { |entry| "#{(entry[0..entry.index(":")])[0..-2].colorize(:red)}:#{entry.gsub(entry[0..entry.index(":")],"").colorize(:green)}" }

                puts "\t#{ISM::Default::CommandLine::MissingSelectionText.colorize(:magenta)} #{dependencySet.join(" | ")}"
            end

            puts "\n"
        end

        def showTaskCompilationTitleMessage
            puts
            print "#{ISM::Default::CommandLine::TaskCompilationText}"
        end

        def showTaskCompilationFailedMessage
            cleanCalculationAnimation
            print "#{ISM::Default::CommandLine::TaskCompilationFailedText.colorize(Colorize::ColorRGB.new(255,100,100))}\n"
        end

        def showCalculationDoneMessage
            cleanCalculationAnimation
            print "#{ISM::Default::CommandLine::CalculationDoneText.colorize(:green)}\n"
        end

        def showCalculationTitleMessage
            puts
            print "#{ISM::Default::CommandLine::CalculationTitle}"
        end

        def showSoftwares(neededSoftwares : Array(ISM::SoftwareInformation), mode = :installation)
            checkedSoftwares = Array(String).new

            puts "\n"

            neededSoftwares.each_with_index do |software, index|
                softwareText = "#{"@#{software.port}".colorize(:red)}:#{software.name.colorize(:green)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/"
                optionsText = "{ "

                if software.options.empty?
                    optionsText += "#{"#{ISM::Default::CommandLine::NoOptionText} ".colorize(:dark_gray)}"
                end

                software.options.each do |option|
                    if option.active
                        optionsText += "#{option.name.colorize(:red)}"
                    else
                        optionsText += "#{option.name.colorize(:blue)}"
                    end
                    optionsText += " "
                end

                optionsText += "}"

                additionalText = ""

                if mode == :installation
                    additionalText += "(#{(software.type+":").colorize(:light_magenta)} "

                    #Codependency case
                    if checkedSoftwares.includes?(software.hiddenName)
                        additionalText += "#{ISM::Default::CommandLine::RebuildDueOfCodependencyText.colorize(:yellow)}"
                    else

                        status = getSoftwareStatus(software)

                        case status
                        when :new
                            additionalText += "#{ISM::Default::CommandLine::NewText.colorize(:yellow)}"
                        when :additionalVersion
                            additionalText += "#{ISM::Default::CommandLine::AdditionalVersionText.colorize(:yellow)}"
                        when :update
                            additionalText += "#{ISM::Default::CommandLine::UpdateText.colorize(:yellow)}"
                        when :buildingPhase
                            additionalText += "#{ISM::Default::CommandLine::BuildingPhaseText.colorize(:yellow)} #{software.getEnabledPassNumber.colorize(:yellow)}"
                        when :optionUpdate
                            additionalText += "#{ISM::Default::CommandLine::OptionUpdateText.colorize(:yellow)}"
                        when :rebuild
                            additionalText += "#{ISM::Default::CommandLine::RebuildText.colorize(:yellow)}"
                        end
                    end

                    additionalText += ")"
                end

                checkedSoftwares.push(software.hiddenName)

                puts "\t" + softwareText + " " + optionsText + " " + additionalText + "\n"
            end

            puts "\n"
        end

        def showInstallationQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + ISM::Default::CommandLine::InstallSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{ISM::Default::CommandLine::InstallQuestion}" +
                    "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                    "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
        end

        def showUninstallationQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + ISM::Default::CommandLine::UninstallSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{ISM::Default::CommandLine::UninstallQuestion.colorize}" +
                    "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                    "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
        end

        def showUpdateQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + ISM::Default::CommandLine::UpdateSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{ISM::Default::CommandLine::UpdateQuestion.colorize.mode(:underline)}" +
                    "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                    "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
        end

        def getUserAgreement : Bool

            loop do
                userInput = gets.to_s

                if userInput.downcase == ISM::Default::CommandLine::YesReplyOption.downcase || userInput.downcase == ISM::Default::CommandLine::YesShortReplyOption.downcase
                    return true
                elsif userInput.downcase == ISM::Default::CommandLine::NoReplyOption.downcase || userInput.downcase == ISM::Default::CommandLine::NoShortReplyOption.downcase
                    return false
                else
                    return false
                end

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getUserAgreement",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def updateInstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
            setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::InstallingText} @#{port}:#{name}#{passNumber == 0 ? "" : " (Pass#{passNumber})"} /#{version}/")

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "updateInstallationTerminalTitle",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def updateUninstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String)
            setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::UninstallingText} @#{port}:#{name} /#{version}/")

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "updateUninstallationTerminalTitle",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def cleanBuildingDirectory(path : String)
            if Dir.exists?(path)
                FileUtils.rm_r(path)
            end

            Dir.mkdir_p(path)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "cleanBuildingDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def showSeparator
            puts "\n"
            puts "#{ISM::Default::CommandLine::Separator.colorize(:green)}\n"
            puts "\n"
        end

        def showEndSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
            puts
            puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)}#{passNumber == 0 ? "" : " (Pass#{passNumber})".colorize(:yellow)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    " #{ISM::Default::CommandLine::InstalledText} " +
                    "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                    "#{">>".colorize(:light_magenta)}" +
                    "\n"
        end

        def showEndSoftwareUninstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
            puts
            puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    " #{ISM::Default::CommandLine::UninstalledText} " +
                    "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                    "#{">>".colorize(:light_magenta)}" +
                    "\n"
        end

        def showInstallationDetailsMessage(softwareNumber : UInt32)
            title = ISM::Default::CommandLine::InstallationDetailsText
            limit = title.size

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "="
            end

            separatorText = "#{separatorText.colorize(:green)}\n"

            puts    separatorText +
                    "#{title.colorize(:green)}\n" +
                    separatorText +
                    "#{ISM::Default::CommandLine::NewSoftwareNumberDetailText.colorize(:green)}: #{softwareNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{ISM::Default::CommandLine::NewDirectoryNumberDetailText.colorize(:green)}: #{@totalInstalledDirectoryNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{ISM::Default::CommandLine::NewSymlinkNumberDetailText.colorize(:green)}: #{@totalInstalledSymlinkNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{ISM::Default::CommandLine::NewFileNumberDetailText.colorize(:green)}: #{@totalInstalledFileNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{ISM::Default::CommandLine::InstalledSizeDetailText.colorize(:green)}: #{@totalInstalledSize.humanize_bytes.colorize(Colorize::ColorRGB.new(255,100,100))}\n"
            puts
        end

        def recordInstallationDetails(directoryNumber : UInt128, symlinkNumber : UInt128, fileNumber : UInt128, totalSize : UInt128)
            @totalInstalledDirectoryNumber += directoryNumber
            @totalInstalledSymlinkNumber += symlinkNumber
            @totalInstalledFileNumber += fileNumber
            @totalInstalledSize += totalSize

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "recordInstallationDetails",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getRequiredLibraries : String
            requireFileContent = File.read_lines("/#{ISM::Default::Path::LibraryDirectory}#{ISM::Default::Filename::RequiredLibraries}")
            requiredLibraries = String.new

            requireFileContent.each do |line|
                if line.includes?("require \".")
                    newLine = line.gsub("require \".","{{ read_file(\"/#{ISM::Default::Path::LibraryDirectory}")+"\n"
                    newLine = newLine.insert(-3,".cr")+").id }}"+"\n"
                    requiredLibraries += newLine
                else
                    requiredLibraries += line+"\n"
                end
            end

            return requiredLibraries

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getRequiredDependencies",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getRequestedSoftwareFullVersionNames
            result = "requestedSoftwareFullVersionNames = ["

            @requestedSoftwares.each_with_index do |software, index|

                if @requestedSoftwares.size == 1
                    result = "requestedSoftwareFullVersionNames = [\"#{software.fullVersionName}\"]"
                else
                    if index == 0
                        result += "\t\"#{software.fullVersionName}\",\n"
                    elsif index != @requestedSoftwares.size-1
                        result += "\t\t\t\t\t\t\t\t\t\"#{software.fullVersionName}\",\n"
                    else
                        result += "\t\t\t\t\t\t\t\t\t\"#{software.fullVersionName}\"]\n"
                    end
                end

            end

            return result

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getRequestedSoftwareFullVersionNames",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getRequiredTargets(neededSoftwares : Array(ISM::SoftwareInformation)) : String
            requiredTargetArrayResult = "targets = ["
            requiredTargetOptionsResult = "\n"
            requiredTargetClassResult = String.new

            additionalInformationNumber = 0
            indexResult = "targetsAdditionalInformationIndex = ["

            neededSoftwares.each_with_index do |software, index|
                #GENERATE TARGET ARRAY
                if neededSoftwares.size == 1
                    requiredTargetArrayResult += "Target#{index}.new(\"#{software.filePath}\")]"
                else
                    if index == 0
                        requiredTargetArrayResult += "\tTarget#{index}.new(\"#{software.filePath}\"),\n"
                    elsif index != neededSoftwares.size-1
                        requiredTargetArrayResult += "\t\t\t\t\t\t\t\t\tTarget#{index}.new(\"#{software.filePath}\"),\n"
                    else
                        requiredTargetArrayResult += "\t\t\t\t\t\t\t\t\tTarget#{index}.new(\"#{software.filePath}\")]\n"
                    end
                end

                #GENERATE TARGET OPTION ARRAY
                software.options.each do |option|
                    if option.active
                        requiredTargetOptionsResult += "targets[#{index}].information.enableOption(\"#{option.name}\")\n"
                    else
                        requiredTargetOptionsResult += "targets[#{index}].information.disableOption(\"#{option.name}\")\n"
                    end
                end

                #ITERATE ALL CLASS FILES
                fileContent = File.read_lines(software.requireFilePath)

                fileContent.each_with_index do |line, lineIndex|

                    #GENERATE TARGET CLASS BY INDEX
                    if lineIndex == 0
                        #Mark point for the task error parsor
                        requiredTargetClassResult += "\n#TARGET#{index}##{software.filePath}"
                        requiredTargetClassResult += "\n#{line.gsub("Target","Target#{index}")}"
                    else
                        requiredTargetClassResult += "\n#{line}"
                    end

                    #GENERATE ADDITIONAL INFORMATION INDEX ARRAY
                    if line.includes?("def showInformations")

                        if additionalInformationNumber >= 1
                            indexResult += ",\n"
                        end

                        if additionalInformationNumber == 0
                            indexResult += "\t#{index}"
                        elsif index != neededSoftwares.size-1
                            indexResult += "\t\t\t\t\t\t\t\t\t#{index}"
                        else
                            indexResult += "\t\t\t\t\t\t\t\t\t#{index}"
                        end

                        additionalInformationNumber += 1
                    end

                end

                requiredTargetClassResult += "\n"
            end

            indexResult += "]\n"

            if additionalInformationNumber == 0
                indexResult = "targetsAdditionalInformationIndex = Array(Int32).new\n"
            end

            return  requiredTargetClassResult +
                    requiredTargetArrayResult +
                    requiredTargetOptionsResult +
                    indexResult

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getRequiredTargets",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def makeLogDirectory(path : String)
            if !Dir.exists?(path)
                Dir.mkdir_p(path)
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "makeLogDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def startInstallationProcess(neededSoftwares : Array(ISM::SoftwareInformation))
            tasks = <<-CODE
                    puts

                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareFullVersionNames}

                    #LOADING TARGETS, ADDITIONAL INFORMATION INDEX AND NEEDED OPTIONS
                    #{getRequiredTargets(neededSoftwares)}
                    #END TARGET SECTION

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase

                    limit = targets.size

                    targets.each_with_index do |target, index|
                        Ism.loadSystemInformationFile

                        information = target.information
                        port = information.port
                        name = information.name
                        version = information.version
                        passNumber = information.getEnabledPassNumber
                        fullVersionName = information.fullVersionName
                        coloredFullVersionName = \"#\{information.fullName.colorize(:magenta)} /#\{version.colorize(Colorize::ColorRGB.new(255,100,100))}/\"

                        #START INSTALLATION PROCESS

                        Ism.updateInstallationTerminalTitle(index, limit, port, name, version, passNumber)

                        Ism.showStartSoftwareInstallingMessage(index, limit, port, name, version, passNumber)

                        Ism.cleanBuildingDirectory(Ism.settings.rootPath+target.information.builtSoftwareDirectoryPath)

                        #Setup
                        begin
                            target.setup
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "setup",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"setup".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.download
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "download",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"download".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.check
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "check",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"check".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.extract
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "extract",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"extract".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.patch
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "patch",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"patch".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.prepare
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "prepare",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"prepare".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.configure
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "configure",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"configure".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.build
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "build",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"build".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.prepareInstallation
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "prepareInstallation",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"prepareInstallation".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            directoryNumber, symlinkNumber, fileNumber, totalSize = target.recordInstallationInformation
                            Ism.recordInstallationDetails(directoryNumber, symlinkNumber, fileNumber, totalSize)
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "recordInstallationInformation",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"recordInstallationInformation".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.install
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "install",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"install".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.recordNeededKernelOptions
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "recordNeededKernelOptions",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"recordNeededKernelOptions".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.clean
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Error.show(className: "Software",
                                            functionName: "clean",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"clean".colorize(:magenta)} process failed for #\{coloredFullVersionName}",
                                            exception: exception)
                        end

                        #Update the ISM instance to make sure the database is up to date and avoiding to reload everything
                        Ism.installedSoftwares.push(target.information)

                        Ism.cleanBuildingDirectory(Ism.settings.rootPath+target.information.builtSoftwareDirectoryPath)

                        Ism.showEndSoftwareInstallingMessage(index, limit, port, name, version, passNumber)

                        if index < limit-1
                            Ism.showSeparator
                        end

                    end

                    targetsAdditionalInformationIndex.each do |index|
                        targets[index].showInformations
                    end

                    Ism.showInstallationDetailsMessage(limit.to_u32)

                    CODE

            generateTasksFile(tasks)

            if Ism.settings.binaryTaskMode
                showTaskCompilationTitleMessage
                buildTasksFile
                showCalculationDoneMessage
            end

            runTasksFile(asBinary: Ism.settings.binaryTaskMode, logEnabled: true, softwareList: neededSoftwares)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "startInstallationProcess",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def buildTasksFile
            processResult = IO::Memory.new

            Process.run("CRYSTAL_WORKERS=#{Ism.settings.systemMakeOptions[2..-1]} crystal build --release #{ISM::Default::Filename::Task}.cr -o #{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task} -f json",
                        error: processResult,
                        shell: true,
                        chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}") do |process|
                loop do
                    playCalculationAnimation(ISM::Default::CommandLine::CompilationWaitingText)
                    Fiber.yield
                    break if process.terminated?
                end
            end

            processResult.rewind

            if processResult.to_s != ""
                taskError = Array(ISM::TaskBuildingProcessError).from_json(processResult.to_s.gsub("\"size\":null","\"size\":0"))[-1]

                showTaskCompilationFailedMessage
                showTaskBuildingProcessErrorMessage(taskError, "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr")
                exitProgram(code: 1)
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "buildTasksFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def runTasksFile(asBinary = true, logEnabled = false, softwareList = Array(ISM::SoftwareInformation).new)

            command = (asBinary ? "./#{ISM::Default::Filename::Task}" : "crystal #{ISM::Default::Filename::Task}.cr")

            logIOMemory = IO::Memory.new

            logWriter = logEnabled ? IO::MultiWriter.new(STDOUT,logIOMemory) : Process::Redirect::Inherit

            process = Process.run(  command: command,
                                    output: logWriter,
                                    error: logWriter,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if logEnabled

                logs = logIOMemory.to_s.split("#{ISM::Default::CommandLine::Separator.colorize(:green)}\n")

                logs.each_with_index do |log, index|

                    makeLogDirectory("#{@settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{softwareList[index].port}")
                    File.write("#{@settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{softwareList[index].port}/#{softwareList[index].versionName}.log", log)

                end
            end

            if !process.success?
                exitProgram(code: 1)
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "runTasksFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def startUninstallationProcess(unneededSoftwares : Array(ISM::SoftwareInformation))
            tasks = <<-CODE
                    puts "\n"

                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareFullVersionNames}

                    #LOADING TARGETS
                    #{getRequiredTargets(unneededSoftwares)}

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSystemInformationFile
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase
                    Ism.loadInstalledSoftwareDatabase

                    limit = targets.size

                    targets.each_with_index do |target, index|

                        information = target.information
                        port = information.port
                        name = information.name
                        version = information.version
                        versionName = information.versionName

                        #START UNINSTALLATION PROCESS

                        Ism.updateUninstallationTerminalTitle(index, limit, port, name, version)

                        Ism.showStartSoftwareUninstallingMessage(index, limit, port, name, version)

                        begin
                            target.uninstall
                        rescue error
                            Ism.printSystemCallErrorNotification(error)
                            Ism.exitProgram
                        end

                        Ism.showEndSoftwareUninstallingMessage(index, limit, port, name, version)

                        if index < limit-1
                            Ism.showSeparator
                        end

                    end

                    CODE

            generateTasksFile(tasks)

            if Ism.settings.binaryTaskMode
                showTaskCompilationTitleMessage
                buildTasksFile
                showCalculationDoneMessage
            end

            runTasksFile

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "startUninstallationProcess",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def showStartSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
            puts    "#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{ISM::Default::CommandLine::InstallingText} " +
                    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)}#{passNumber == 0 ? "" : " (Pass#{passNumber})".colorize(:yellow)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    "\n\n"
        end

        def showStartSoftwareUninstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
            puts    "\n#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{ISM::Default::CommandLine::UninstallingText} " +
                    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    "\n\n"
        end

        def synchronizePorts
            @ports.each do |port|

                synchronization = port.synchronize

                until synchronization.terminated?
                    playCalculationAnimation(ISM::Default::CommandLine::SynchronizationWaitingText)
                    sleep(Time::Span.new(seconds: 0))
                end

            end

            cleanCalculationAnimation

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "synchronizePorts",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getRequiredDependencies(softwares : Array(ISM::SoftwareInformation), allowRebuild = false, allowDeepSearch = false, allowSkipUnavailable = false) : Hash(String, ISM::SoftwareInformation)

            dependencyHash = Hash(String, ISM::SoftwareInformation).new
            currentDependencies = softwares.map { |entry| entry.toSoftwareDependency}
            nextDependencies = Array(ISM::SoftwareDependency).new
            invalidDependencies = Array(ISM::SoftwareInformation).new

            loop do

                playCalculationAnimation

                if currentDependencies.empty?
                    break
                end

                currentDependencies.each do |dependency|
                    playCalculationAnimation

                    key = dependency.hiddenName
                    dependencyInformation = dependency.information
                    installed = softwareIsInstalled(dependencyInformation)

                    if !installed || installed && allowRebuild  && softwareIsRequestedSoftware(dependencyInformation) && !dependencyInformation.passEnabled || allowDeepSearch || softwares.any? { |entry| entry.hiddenName == key}

                        if !dependencyInformation.isValid

                            invalidDependencies.push(ISM::SoftwareInformation.new(port: dependency.port, name: dependency.name, version: dependency.requiredVersion))

                        end

                        if dependencyHash.has_key?(key)

                            hashOptions = dependencyHash[key].toSoftwareDependency.options.uniq
                            dependencyOptions = dependency.options.uniq

                            differentOptions = !((hashOptions - dependencyOptions | dependencyOptions - hashOptions).empty?)

                            needToEnableNewOnes = (dependencyOptions.any? { |option| !hashOptions.includes?(option)})

                            if differentOptions && needToEnableNewOnes

                                dependency.options.each do |option|
                                    playCalculationAnimation

                                    dependencyHash[key].enableOption(option)
                                end

                                nextDependencies += dependencyHash[key].dependencies(allowDeepSearch)
                            end

                        else
                            dependencyHash[key] = dependencyInformation

                            nextDependencies += dependencyHash[key].dependencies(allowDeepSearch)
                        end

                    end

                end

                currentDependencies = nextDependencies.dup
                nextDependencies.clear

            end

            if !invalidDependencies.empty?

                invalidDependencies.each do |invalidDependency|
                    playCalculationAnimation

                    dependencyHash.values.each do |neededSoftware|
                        playCalculationAnimation

                        neededSoftware.dependencies(allowDeepSearch: true).each do |dependency|
                            playCalculationAnimation

                            information = dependency.information

                            if information.fullVersionName == invalidDependency.fullVersionName
                                reportMissingDependency(missingDependency: invalidDependency, relatedSoftware: neededSoftware)
                            end

                        end

                    end

                end

                if allowSkipUnavailable

                    return Hash(String, ISM::SoftwareInformation).new

                else

                    @unavailableDependencySignals.each do |softwares|
                        showCalculationDoneMessage
                        showUnavailableDependencyMessage(softwares[0],softwares[1])
                        exitProgram
                    end

                end

            end

            return dependencyHash

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getRequiredDependencies",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getDependencyTree(software : ISM::SoftwareInformation, softwareList : Hash(String, ISM::SoftwareInformation), calculatedDependencies = Hash(String, Array(ISM::SoftwareInformation)).new) : Array(ISM::SoftwareInformation)

            dependencies = Hash(String, ISM::SoftwareInformation).new

            currentDependencies = [software.toSoftwareDependency]
            nextDependencies = Array(ISM::SoftwareDependency).new

            loop do

                playCalculationAnimation

                if currentDependencies.empty?
                    break
                end

                currentDependencies.each do |dependency|
                    playCalculationAnimation

                    key = dependency.hiddenName

                    if !dependencies.has_key?(key)

                        if calculatedDependencies.has_key?(key)
                            calculatedDependencies[key].each do |software|
                                playCalculationAnimation

                                dependencies[software.hiddenName] = software
                            end
                        else
                            if softwareList.has_key?(key)
                                dependencies[key] = softwareList[key]
                            else
                                dependencies[key] = software
                            end
                        end

                        nextDependencies += dependencies[key].dependencies
                    end

                end

                currentDependencies = nextDependencies.dup
                nextDependencies.clear

            end

            return dependencies.values

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getDependencyTree",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getDependencyTable(softwareList : Hash(String, ISM::SoftwareInformation)) : Hash(String, Array(ISM::SoftwareInformation))

            calculatedDependencies = Hash(String, Array(ISM::SoftwareInformation)).new

            softwareList.values.each do |software|
                playCalculationAnimation

                calculatedDependencies[software.hiddenName] = getDependencyTree(software, softwareList, calculatedDependencies)

                software.dependencies.each do |dependency|
                    playCalculationAnimation

                    dependencyInformation = dependency.information

                    if !softwareIsInstalled(dependencyInformation)
                        calculatedDependencies[dependency.hiddenName] = getDependencyTree(dependencyInformation, softwareList, calculatedDependencies)
                    end
                end
            end

            keys = calculatedDependencies.keys
            keyToDelete = Array(String).new

            keys.each do |key1|
                playCalculationAnimation

                keys.each do |key2|
                    playCalculationAnimation

                    if key1 != key2

                        if calculatedDependencies[key1].any?{|dependency| dependency.hiddenName == key2} && calculatedDependencies[key2].any?{|dependency| dependency.hiddenName == key1}

                            #Codependency case
                            if softwaresAreCodependent(calculatedDependencies[key1][0], calculatedDependencies[key2][0])
                                #For both entry:
                                #-------------------
                                #If it's related to an optional codependency:
                                #   Clone and delete codependencies from clone list with different name (ex: name-codependency) (disable options if it relative to the options)
                                if !key1.includes?("-#{ISM::Default::CommandLine::CodependencyExtensionText}") && !key2.includes?("-#{ISM::Default::CommandLine::CodependencyExtensionText}") && !calculatedDependencies.has_key?(key1+"-#{ISM::Default::CommandLine::CodependencyExtensionText}") && !calculatedDependencies.has_key?(key2+"-#{ISM::Default::CommandLine::CodependencyExtensionText}")

                                    #RELATED TO OPTION OR DIRECT DEPENDENCY ?
                                    key1HaveOptionalCodependency = calculatedDependencies[key1][0].option(calculatedDependencies[key2][0].name)
                                    key2HaveOptionalCodependency = calculatedDependencies[key2][0].option(calculatedDependencies[key1][0].name)

                                    #--------------------------------------------------------------------
                                    if key1HaveOptionalCodependency
                                        calculatedDependencies[key1+"-#{ISM::Default::CommandLine::CodependencyExtensionText}"] = calculatedDependencies[key1].clone

                                        calculatedDependencies[key1+"-#{ISM::Default::CommandLine::CodependencyExtensionText}"].each do |dependency|
                                            playCalculationAnimation

                                            if dependency.hiddenName == key2
                                                calculatedDependencies[key1].delete(dependency)
                                            end
                                        end

                                        calculatedDependencies[key1+"-#{ISM::Default::CommandLine::CodependencyExtensionText}"][0].options.each do |option|
                                            playCalculationAnimation

                                            option.dependencies.each do |dependency|
                                                if dependency.hiddenName == key2
                                                    calculatedDependencies[key1][0].disableOption(option.name)

                                                    if softwareIsInstalled(calculatedDependencies[key1][0])
                                                        keyToDelete.push(key1)
                                                    end
                                                end
                                            end
                                        end

                                    end
                                    #--------------------------------------------------------------------

                                    #--------------------------------------------------------------------
                                    if key2HaveOptionalCodependency

                                        calculatedDependencies[key2+"-#{ISM::Default::CommandLine::CodependencyExtensionText}"] = calculatedDependencies[key2].clone

                                        calculatedDependencies[key2+"-#{ISM::Default::CommandLine::CodependencyExtensionText}"].each do |dependency|
                                            playCalculationAnimation

                                            if dependency.hiddenName == key1
                                                calculatedDependencies[key2].delete(dependency)
                                            end
                                        end

                                        calculatedDependencies[key2+"-#{ISM::Default::CommandLine::CodependencyExtensionText}"][0].options.each do |option|
                                            playCalculationAnimation

                                            option.dependencies.each do |dependency|
                                                if dependency.hiddenName == key1
                                                    calculatedDependencies[key2][0].disableOption(option.name)

                                                    if softwareIsInstalled(calculatedDependencies[key2][0])
                                                        keyToDelete.push(key2)
                                                    end
                                                end
                                            end
                                        end

                                    end
                                    #--------------------------------------------------------------------

                                end

                            #Inextricable dependency case
                            else
                                showCalculationDoneMessage
                                showInextricableDependenciesMessage([calculatedDependencies[key1],calculatedDependencies[key2]])
                                exitProgram
                            end

                        end
                    end
                end
            end

            keyToDelete.uniq!

            keyToDelete.each do |key|
                calculatedDependencies.delete(key)
            end

            return calculatedDependencies

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getDependencyTable",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getSortedDependencies(dependencyTable : Hash(String, Array(ISM::SoftwareInformation))) : Array(ISM::SoftwareInformation)

            result = dependencyTable.to_a.sort_by { |k, v| v.size }

            return result.map { |entry| entry[1][0]}

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getSortedDependencies",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def generateTasksFile(tasks : String)
            File.write("#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "generateTasksFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getNeededSoftwares : Array(ISM::SoftwareInformation)
            softwareHash = getRequiredDependencies(@requestedSoftwares, allowRebuild: true)

            dependencyTable = getDependencyTable(softwareHash)

            return getSortedDependencies(dependencyTable)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getNeededSoftwares",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getUnneededSoftwares : Array(ISM::SoftwareInformation)
            wrongArguments = Array(String).new
            requiredSoftwares = Hash(String,ISM::SoftwareInformation).new
            unneededSoftwares = Array(ISM::SoftwareInformation).new
            softwareList = Array(String).new
            softwareInformationList = Array(ISM::SoftwareInformation).new

            #Generate a list of all favourite softwares
            @favouriteGroups.each do |group|
                playCalculationAnimation

                softwareList += group.softwares
            end

            #Remove from that list requested softwares for removal
            @requestedSoftwares.each do |software|
                playCalculationAnimation

                if softwareList.includes?(software.fullVersionName)
                    softwareList.delete(software.fullVersionName)
                end
            end

            #Generate a software information array of the left favourites
            softwareInformationList = getRequestedSoftwares(softwareList)

            #Then we check the needed dependencies for that list
            requiredSoftwares = getRequiredDependencies(softwareInformationList, allowDeepSearch: true)

            #Checking if the requested softwares for removal are not require
            @requestedSoftwares.each do |software|
                playCalculationAnimation

                #If it's require, add to wrong arguments
                if requiredSoftwares.has_key?(software.fullVersionName)
                    wrongArguments.push(software.fullVersionName)
                end
            end

            #Then check if some installed softwares are useless
            @installedSoftwares.each do |software|
                playCalculationAnimation

                #If it's not require, add to unneeded softwares
                if !requiredSoftwares.has_key?(software.fullVersionName)
                    unneededSoftwares.push(software)
                end

            end

            if !wrongArguments.empty?
                showCalculationDoneMessage
                showSoftwareNeededMessage(wrongArguments)
                exitProgram
            end

            return unneededSoftwares

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getUnneededSoftwares",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getSoftwaresToUpdate : Array(ISM::SoftwareInformation)
            softwareToUpdate = Array(ISM::SoftwareInformation).new
            skippedUpdates = false

            #FOR EACH INSTALLED SOFTWARE, WE CHECK IF THERE IS ANY BETTER VERSION
            @installedSoftwares.each do |installedSoftware|

                playCalculationAnimation

                #We check all available softwares in the database
                @softwares.each do |availableSoftware|

                    playCalculationAnimation

                    currentVersion = SemanticVersion.parse(installedSoftware.version)
                    greatestSoftware = availableSoftware.greatestVersion
                    greatestVersion = SemanticVersion.parse(greatestSoftware.version)

                    if installedSoftware.fullName == availableSoftware.fullName
                        #TO DO: Add a condition for the case when there is an update for the kernel
                        if currentVersion < greatestVersion && !softwareIsInstalled(greatestSoftware)
                            #We test first if the software is installable
                            installable = !(getRequiredDependencies([greatestSoftware],allowSkipUnavailable: true)).empty?

                            if !installable
                                skippedUpdates = true
                            else
                                #Missing options check from the previous version
                                softwareToUpdate.push(greatestSoftware)
                            end

                        end
                    end

                end

            end

            showCalculationDoneMessage

            #IF THERE IS ANY SKIPPED UPDATES, WE NOTICE THE USER
            if skippedUpdates
                showSkippedUpdatesMessage

                #Remove duplicate skipped updates
                @unavailableDependencySignals.uniq! { |entry| [entry[0].fullVersionName,entry[1].fullVersionName]}

                #Show all skipped updates
                @unavailableDependencySignals.each do |signal|
                    showUnavailableDependencyMessage(signal[0], signal[1], allowTitle: false)
                end

            end

            #NEEDED to check if any of the updated software is a dependency of any required software for the system

            puts

            return softwareToUpdate

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getSoftwaresToUpdate",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def addPatch(path : String, softwareVersionName : String) : Bool
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{softwareVersionName}")
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{softwareVersionName}")
            end

            patchFileName = path.lchop(path[0..path.rindex("/")])

            begin
                FileUtils.cp(   path,
                                @settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{softwareVersionName}/#{patchFileName}")
            rescue
                return false
            end

            return true

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "addPatch",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def deletePatch(patchName : String, softwareVersionName : String) : Bool
            path = @settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{softwareVersionName}/#{patchName}"

            begin
                FileUtils.rm(path)
            rescue
                return false
            end

            return true

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "deletePatch",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Relative to chroot
        def taskRelativeDirectoryPath : String
            root = ((@systemInformation.handleChroot || !@systemInformation.handleChroot && @settings.rootPath != "/") ? "/" : @settings.rootPath)

            return "#{root}#{ISM::Default::Path::TemporaryDirectory}"
        end

        #Relative to chroot
        def taskRelativeFilePath : String
            return "#{taskRelativeDirectoryPath}#{ISM::Default::Filename::Task}"
        end

        def taskAbsoluteDirectoryPath : String
            return "#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}"
        end

        def taskAbsoluteFilePath : String
            return "#{taskAbsoluteDirectoryPath}#{ISM::Default::Filename::Task}"
        end

        def hostSystemInformation : ISM::CommandLineSystemInformation
            filePath = "/#{ISM::Default::CommandLineSystemInformation::SystemInformationFilePath}"

            return ISM::CommandLineSystemInformation.loadConfiguration(filePath)
        end

        def targetSystemInformation : ISM::CommandLineSystemInformation
            filePath = "#{@settings.rootPath}#{ISM::Default::CommandLineSystemInformation::SystemInformationFilePath}"

            return ISM::CommandLineSystemInformation.loadConfiguration(filePath)
        end

        def runTasks(   tasks : String,
                        asRoot = false,
                        viaChroot = false,
                        quiet = false) : Process::Status
            quietMode = (quiet ? Process::Redirect::Close : Process::Redirect::Inherit)

            # We first check if there is any task left
            if File.exists?("#{taskAbsoluteFilePath}")
                process = Process.run(  command: "sudo rm #{taskAbsoluteFilePath}",
                                        shell: true)
            end

            if !Dir.exists?(taskAbsoluteDirectoryPath)
                Dir.mkdir_p(taskAbsoluteDirectoryPath)
            end

            File.write(taskAbsoluteFilePath, tasks)

            process = Process.run(  command:    "sudo chmod +x #{taskAbsoluteFilePath}",
                                    input:      quietMode,
                                    output:     quietMode,
                                    error:      quietMode,
                                    shell:      true)

            if viaChroot
                superuser = "--userspec=#{ISM::Default::CommandLine::Id.to_s}:#{ISM::Default::CommandLine::Id.to_s}"

                command = "HOME=/var/lib/ism sudo chroot #{superuser} #{@settings.rootPath} #{taskRelativeFilePath}"
            else
                command = "#{asRoot ? "sudo" : ""} #{taskAbsoluteFilePath}"
            end

            process = Process.run(  command:    command,
                                    input:      quietMode,
                                    output:     quietMode,
                                    error:      quietMode,
                                    shell:      true)

            return process

            rescue exception
                raisedError =  <<-ERROR
                System command failure
                command: #{command}
                viaChroot: #{viaChroot}
                ERROR

                ISM::Error.show(className: "CommandLine",
                                functionName: "runTasks",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the following process:\n#{raisedError}",
                                exception: exception)
        end

        def runSystemCommand(   command : String,
                                path = "/", environment = Hash(String, String).new,
                                environmentFilePath = String.new,
                                quiet = false,
                                asRoot = false,
                                viaChroot = true) : Process::Status

            quietMode = (quiet ? Process::Redirect::Close : Process::Redirect::Inherit)
            rootMode = false

            environmentCommand = String.new
            profile = String.new

            if environmentFilePath != ""
                environmentCommand = "source \"#{environmentFilePath}\" && "
            end

            environment.keys.each do |key|
                environmentCommand += "#{key}=\"#{environment[key]}\" "
            end

            if targetSystemInformation.handleChroot || !targetSystemInformation.handleChroot && @settings.rootPath == "/"
                profile = <<-PROFILE
                if \[ -f "/etc/profile" \]; then
                    source /etc/profile
                fi
                PROFILE

                rootMode = asRoot
            else
                profile = <<-PROFILE
                umask 022
                LC_ALL=POSIX
                PATH=#{@settings.toolsPath}/bin:/usr/bin:/usr/sbin
                PROFILE
            end

            tasks = <<-TASKS
            #!/bin/bash

            #{profile}

            cd #{path} && #{environmentCommand} #{command}
            TASKS

            process = runTasks( tasks: tasks,
                                asRoot: rootMode,
                                viaChroot: targetSystemInformation.handleChroot,
                                quiet: quiet)

            #TRACELOG-------------------------------------------------------------
            ISM::TraceLog.record(   accessor:   "CommandLine",
                                    function:   "runSystemCommand",
                                    message:    <<-TEXT
                                    Running command:
                                    #{tasks}
                                    TEXT
            )
            #-------------------------------------------------------------TRACELOG

            return process

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "runSystemCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def runFile(file : String, arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "./#{file} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "runFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        # setKernelOption(symbol : String, state : Symbol, value = String.new)
        # state = :enable, :disable, :module, :string, :value

        def getNeededKernelOptions : Array(ISM::NeededKernelOption)

            #1 - We perform a first pass to record the options that don't need any special requirements
            @neededKernelOptions.each do |option|

                if option.singleChoiceDependencies.empty? && option.blockers.empty?
                    #(option.tristate && @settings.buildKernelOptionsAsModule ? true : false)

                end

            end

            #return

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getNeededKernelOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def generateDefaultKernelConfig
            requestedCommands = "make #{@settings.systemMakeOptions} defconfig"
            path = kernelSourcesPath

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                notifyOfRunSystemCommandError(requestedCommands, path)
                exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "generateDefaultKernelConfig",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def generateKernelConfig

        end

        def generateKernel
            requestedCommands = "make #{@settings.systemMakeOptions} mrproper && make #{@settings.systemMakeOptions} modules_prepare && make #{@settings.systemMakeOptions} && make #{@settings.systemMakeOptions} modules_install && make #{@settings.systemMakeOptions} install"
            path = kernelSourcesPath

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                notifyOfRunSystemCommandError(requestedCommands, path)
                exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "generateKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def installKernel
            requestedCommands = "mv System.map /boot/System.map-linux-#{mainKernelVersion} && mv vmlinuz /boot/vmlinuz-linux-#{mainKernelVersion} && cp .config /boot/config-linux-#{mainKernelVersion}"
            path = kernelSourcesPath

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                notifyOfRunSystemCommandError(requestedCommands, path)
                exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "installKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def mainKernelName : String
            return selectedKernel.versionName.downcase
        end

        def mainKernelHeadersName : String
            return "#{selectedKernel.name.downcase}-headers-#{selectedKernel.version.downcase}"
        end

        def mainKernelVersion : String
            return selectedKernel.version
        end

        def kernelSourcesPath : String
            return "#{@settings.rootPath}usr/src/#{mainKernelName}/"
        end

        def kernelConfigPath : String
            return "#{kernelSourcesPath}/.config"
        end

        def setKernelOption(symbol : String, state : Symbol, value = String.new)
            case state
            when :enable
                arguments = ["-e","#{symbol}"]
            when :disable
                arguments = ["-d","#{symbol}"]
            when :module
                arguments = ["-m","#{symbol}"]
            when :string
                arguments = ["--set-str","#{symbol}",value]
            when :value
                arguments = ["--set-val","#{symbol}",value]
            end

            runFile("#{kernelSourcesPath}/config",arguments,"#{kernelSourcesPath}/scripts")

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "setKernelOption",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
