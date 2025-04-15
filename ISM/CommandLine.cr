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
        property initialTerminalTitle : String
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

        def systemId : String
            return ISM::Default::Core::Security::SystemId

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "systemId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def start
            setup
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "start",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #TO DO: CLEAN ONLY IF TASKS IS NOT RUNNING (IN FUTUR FOR MULTITASKING)
        def setup
            #Required directories for ISM
            mainTree = [ISM::Default::Path::RuntimeDataDirectory,
                        ISM::Default::Path::TemporaryDirectory,
                        ISM::Default::Path::SettingsDirectory,
                        ISM::Default::Path::LogsDirectory,
                        ISM::Default::Path::LibraryDirectory]

            #We generate them and set proper rights (for host and guest if needed)
            mainTree.each do |entry|
                if !Dir.exists?(entry)
                    if @settings.rootPath != "/"
                        ISM::Core.runSystemCommand( command: "mkdir -p #{@settings.rootPath}#{entry}",
                                                asRoot: true,
                                                viaChroot: false)

                        ISM::Core.runSystemCommand( command: "chown -R #{ISM::Default::Core::SystemUserId}:#{ISM::Default::Core::SystemUserId} #{@settings.rootPath}#{entry}",
                                                    asRoot: true,
                                                    viaChroot: false)
                    end

                    ISM::Core.runSystemCommand( command: "mkdir -p #{entry}",
                                                asRoot: true,
                                                viaChroot: false)

                    ISM::Core.runSystemCommand( command: "chown -R #{ISM::Default::Core::SystemUserId}:#{ISM::Default::Core::SystemUserId} #{entry}",
                                                asRoot: true,
                                                viaChroot: false)
                end
            end

            #We clean any leftover from previous tasks
            #Error are bypassed because if there is no leftover, it's not a critical issue
            if @settings.rootPath != "/"
                ISM::Core.runSystemCommand( command: "chattr -f -i #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::TaskPrefix}* > /dev/null 2>&1 || true",
                                            asRoot: true,
                                            viaChroot: false)

                ISM::Core.runSystemCommand( command: "rm #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::TaskPrefix}* > /dev/null 2>&1 || true",
                                            asRoot: true,
                                            viaChroot: false)
            end

            ISM::Core.runSystemCommand( command: "chattr -f -i /#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::TaskPrefix}* > /dev/null 2>&1 || true",
                                            asRoot: true,
                                            viaChroot: false)

            ISM::Core.runSystemCommand( command: "rm /#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::TaskPrefix}* > /dev/null 2>&1 || true",
                                        asRoot: true,
                                        viaChroot: false)
        end

        def loadNeededKernelOptions
            directory = "#{@settings.rootPath}#{ISM::Default::Path::NeededKernelOptionsDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            neededKernelOptions = Dir.children(directory)

            neededKernelOptions.each do |option|

                @neededKernelOptions << ISM::NeededKernelOption.loadConfiguration("#{directory}/#{option}")

            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadNeededKernelOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadKernelOptionDatabase
            directory = "#{@settings.rootPath}#{ISM::Default::Path::KernelOptionsDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            availableKernels = Dir.children(directory)

            availableKernels.each do |kernelDirectory|

                kernelOptionFiles = Dir.children("#{directory}/#{kernelDirectory}")

                availableKernel = ISM::AvailableKernel.new(kernelDirectory)

                kernelOptionFiles.each do |kernelOptionFile|
                    availableKernel.options << ISM::KernelOption.loadConfiguration("#{directory}/#{kernelDirectory}/#{kernelOptionFile}")
                end

                @kernels << availableKernel

            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadKernelOptionDatabase",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadSoftware(port : String, name : String, version : String) : ISM::SoftwareInformation
            directory = "#{@settings.rootPath}#{ISM::Default::Path::SoftwaresDirectory}#{port}/#{name}/#{version}/#{ISM::Default::Filename::Information}"
            "#{@settings.rootPath}#{ISM::Default::Path::SettingsSoftwaresDirectory}#{port}/#{name}/#{version}/#{ISM::Default::Filename::SoftwareSettings}"
            settingsDirectory = "#{@settings.rootPath}#{ISM::Default::Path::SettingsSoftwaresDirectory}#{port}/#{name}/#{version}/#{ISM::Default::Filename::SoftwareSettings}"

            software = ISM::SoftwareInformation.loadConfiguration(directory)

            if File.exists?(settingsDirectory)

                softwareSettings = ISM::SoftwareInformation.loadConfiguration(settingsDirectory)

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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadSoftware",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadSoftwareDatabase
            directory = "#{@settings.rootPath}#{ISM::Default::Path::SoftwaresDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            portDirectories = Dir.children(directory)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children("#{directory}#{portDirectory}").reject!(&.starts_with?(".git"))

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children("#{directory}#{portDirectory}/#{softwareDirectory}")
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadSoftwareDatabase",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadPortsDatabase
            directory = "#{@settings.rootPath}#{ISM::Default::Path::PortsDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            portsFiles = Dir.children(directory)

            portsFiles.each do |portFile|
                path = ISM::Port.filePath(portFile[0..-6])
                @ports << ISM::Port.loadConfiguration(path)
            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadPortsDatabase",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadMirrorsDatabase
            directory = "#{@settings.rootPath}#{ISM::Default::Path::MirrorsDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            mirrorsFiles = Dir.children(directory)

            if mirrorsFiles.size == 0
                @mirrors << ISM::Mirror.loadConfiguration
            else
                mirrorsFiles.each do |mirrorFile|
                    path = ISM::Mirror.filePath(mirrorFile[0..-6])
                    @mirrors << ISM::Mirror.loadConfiguration(path)
                end
            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadMirrorsDatabase",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadFavouriteGroupsDatabase
            directory = "#{@settings.rootPath}#{ISM::Default::Path::FavouriteGroupsDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            favouriteGroupsFiles = Dir.children(directory)

            if favouriteGroupsFiles.size == 0
                @favouriteGroups << ISM::FavouriteGroup.loadConfiguration
            else
                favouriteGroupsFiles.each do |favouriteGroupFile|
                    path = ISM::FavouriteGroup.filePath(favouriteGroupFile[0..-6])
                    @favouriteGroups << ISM::FavouriteGroup.loadConfiguration(path)
                end
            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadFavouriteGroupsDatabase",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadSystemInformationFile
            @systemInformation = ISM::CommandLineSystemInformation.loadConfiguration

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadSystemInformationFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadSettingsFiles
            @settings = ISM::CommandLineSettings.loadConfiguration
            @portsSettings = ISM::CommandLinePortsSettings.loadConfiguration
            @mirrorsSettings = ISM::CommandLineMirrorsSettings.loadConfiguration

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadInstalledSoftware",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def loadInstalledSoftwareDatabase
            directory = "#{@settings.rootPath}#{ISM::Default::Path::InstalledSoftwaresDirectory}"

            if !Dir.exists?(directory)
                Dir.mkdir_p(directory)
            end

            portDirectories = Dir.children(directory)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children("#{directory}#{portDirectory}")

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children("#{directory}#{portDirectory}/#{softwareDirectory}")

                    versionDirectories.each do |versionDirectory|

                        @installedSoftwares << loadInstalledSoftware(portDirectory, softwareDirectory, versionDirectory)

                    end

                end

            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "loadInstalledSoftwareDatabase",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "inputMatchWithFilter",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def reportMissingDependency(missingDependency : ISM::SoftwareInformation, relatedSoftware : ISM::SoftwareInformation)
            @unavailableDependencySignals.push([relatedSoftware, missingDependency])

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "reportMissingDependency",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def addInstalledSoftware(softwareInformation : ISM::SoftwareInformation, installedFiles = Array(String).new)
            softwareInformation.installedFiles = installedFiles
            softwareInformation.writeConfiguration(softwareInformation.installedFilePath)

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "softwareIsInstalled",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def softwaresAreCodependent(software1 : ISM::SoftwareInformation, software2 : ISM::SoftwareInformation) : Bool
            return software1.allowCodependencies.includes?(software2.fullName) && software2.allowCodependencies.includes?(software1.fullName) && !software1.passEnabled && !software2.passEnabled

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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

                #TO DO
                #There are more than one match, the user need to specify a port (Ambiguous)
                if matches.size > 1
                    ISM::Core::Notification.ambiguousSearchMessage(matches)
                    ISM::Core.exitProgram
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getSoftwareInformation",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def checkEnteredArguments
            matchingOption = false

            terminalTitleArguments = (ARGV.empty? ? "" : ARGV.join(" "))
            ISM::Core.setTerminalTitle("#{ISM::Default::CommandLine::Name} #{terminalTitleArguments}")

            if ARGV.empty?
                matchingOption = true
                @options[0].start
                ISM::Core.resetTerminalTitle
            else
                @options.each_with_index do |argument, index|

                    if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                        matchingOption = true
                        @options[index].start
                        ISM::Core.resetTerminalTitle
                        break
                    end

                end
            end

            if !matchingOption
                ISM::Core::Notification.errorUnknowArgument
            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "checkEnteredArguments",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def resetCalculationAnimation
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "resetCalculationAnimation",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getRequestedSoftwares",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getUserAgreement",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def updateInstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
            ISM::Core.setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::InstallingText} @#{port}:#{name}#{passNumber == 0 ? "" : " (Pass#{passNumber})"} /#{version}/")

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "updateInstallationTerminalTitle",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def updateUninstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String)
            ISM::Core.setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::UninstallingText} @#{port}:#{name} /#{version}/")

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "cleanBuildingDirectory",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def recordInstallationDetails(directoryNumber : UInt128, symlinkNumber : UInt128, fileNumber : UInt128, totalSize : UInt128)
            @totalInstalledDirectoryNumber += directoryNumber
            @totalInstalledSymlinkNumber += symlinkNumber
            @totalInstalledFileNumber += fileNumber
            @totalInstalledSize += totalSize

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getRequiredLibraries",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "makeLogDirectory",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def startInstallationProcess(neededSoftwares : Array(ISM::SoftwareInformation))
            tasks = <<-CODE
                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareFullVersionNames}

                    #LOADING TARGETS, ADDITIONAL INFORMATION INDEX AND NEEDED OPTIONS
                    #{getRequiredTargets(neededSoftwares)}
                    #END TARGET SECTION

                    puts

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSystemInformationFile
                    Ism.loadSoftwareDatabase

                    limit = targets.size

                    targets.each_with_index do |target, index|

                        information = target.information
                        port = information.port
                        name = information.name
                        version = information.version
                        passNumber = information.getEnabledPassNumber
                        fullVersionName = information.fullVersionName

                        #START INSTALLATION PROCESS

                        Ism.updateInstallationTerminalTitle(index, limit, port, name, version, passNumber)

                        ISM::Core::Notification.startSoftwareInstallingMessage(index, limit, port, name, version, passNumber)

                        Ism.cleanBuildingDirectory(Ism.settings.rootPath+target.information.builtSoftwareDirectoryPath)

                        begin
                            target.setup
                            target.download
                            target.check
                            target.extract
                            target.patch
                            target.prepare
                            target.configure
                            target.build
                            target.prepareInstallation

                            directoryNumber, symlinkNumber, fileNumber, totalSize = target.recordInstallationInformation
                            Ism.recordInstallationDetails(directoryNumber, symlinkNumber, fileNumber, totalSize)

                            target.install
                            target.recordNeededKernelOptions
                            target.clean
                        rescue exception
                            Ism.uninstallSoftware(target.information)

                            ISM::Core::Error.show(  className: "None",
                                                    functionName: "None",
                                                    errorTitle: "Installation task failed",
                                                    error: "The current target installation failed",
                                                    exception: exception)
                        end

                        #Update the ISM instance to make sure the database is up to date and avoiding to reload everything
                        Ism.installedSoftwares.push(target.information)

                        Ism.cleanBuildingDirectory(Ism.settings.rootPath+target.information.builtSoftwareDirectoryPath)

                        ISM::Core::Notification.endSoftwareInstallingMessage(index, limit, port, name, version, passNumber)

                        if index < limit-1
                            ISM::Core::Notification.separator
                        end

                    end

                    targetsAdditionalInformationIndex.each do |index|
                        targets[index].showInformations
                    end

                    ISM::Core::Notification.installationDetailsMessage(limit.to_u32)

                    CODE

            generateTasksFile(tasks)

            if Ism.settings.binaryTaskMode
                ISM::Core::Notification.taskCompilationTitleMessage
                buildTasksFile
                ISM::Core::Notification.calculationDoneMessage
            end

            runTasksFile(asBinary: Ism.settings.binaryTaskMode, logEnabled: true, softwareList: neededSoftwares)

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "startInstallationProcess",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def buildTasksFile
            processResult = IO::Memory.new

            requestedCommands = "CRYSTAL_WORKERS=#{Ism.settings.systemMakeOptions[2..-1]} crystal build #{ISM::Default::Filename::Task}.cr -o #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task} -f json"

            Process.run(command: requestedCommands,
                        error: processResult,
                        chdir: "#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}") do |process|
                loop do
                    playCalculationAnimation(ISM::Default::CommandLine::CompilationWaitingText)
                    Fiber.yield
                    break if process.terminated?
                end
            end

            processResult.rewind

            if processResult.to_s != ""
                taskError = Array(ISM::TaskBuildingProcessError).from_json(processResult.to_s.gsub("\"size\":null","\"size\":0"))[-1]

                ISM::Core::Notification.taskCompilationFailedMessage
                ISM::Core::Notification.taskBuildingProcessErrorMessage(taskError, "#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}.cr")

                ISM::Core::Error.show(  className: "CommandLine",
                                        functionName: "buildTasksFile",
                                        errorTitle: "Task compilation failure",
                                        error: "Failed to compile the requested task")
            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "buildTasksFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def runTasksFile(asBinary = true, logEnabled = false, softwareList = Array(ISM::SoftwareInformation).new)
            # We first set proper rights for the binary and task file:
            #   -owned by ism (uid 250 and gid 250)
            #   -set as immutable to don't allow any suppression

            if asBinary
                ISM::Core.runSystemCommand( command: "/usr/bin/chown #{ISM::Default::Core::Security::SystemId}:#{ISM::Default::Core::Security::SystemId} #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}",
                                        viaChroot: false,
                                        asRoot: true)

                ISM::Core.runSystemCommand( command: "/usr/bin/chattr -f +i #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}",
                                            viaChroot: false,
                                            asRoot: true)
            end

            ISM::Core.runSystemCommand( command: "/usr/bin/chown #{ISM::Default::Core::Security::SystemId}:#{ISM::Default::Core::Security::SystemId} #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}.cr",
                                        viaChroot: false,
                                        asRoot: true)

            ISM::Core.runSystemCommand( command: "/usr/bin/chattr -f +i #{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}.cr",
                                        viaChroot: false,
                                        asRoot: true)

            # Log tracing
            logIOMemory = IO::Memory.new
            logWriter = logEnabled ? IO::MultiWriter.new(STDOUT,logIOMemory) : Process::Redirect::Inherit

            # Task execution
            taskPrefix = (asBinary ? "./" : "crystal ")
            taskExtension = (asBinary ? "" : ".cr")

            ISM::Core.runSystemCommand( command: "#{taskPrefix}#{ISM::Default::Filename::Task}#{taskExtension}",
                                        output: logWriter,
                                        error: logWriter,
                                        viaChroot: false,
                                        path: "#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}")

            # Log recording
            if logEnabled

                logs = logIOMemory.to_s.split("#{ISM::Default::CommandLine::Separator.colorize(:green)}\n")

                logs.each_with_index do |log, index|

                    makeLogDirectory("#{@settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{softwareList[index].port}")
                    File.write("#{@settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{softwareList[index].port}/#{softwareList[index].versionName}.log", log)

                end
            end

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "runTasksFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def startUninstallationProcess(unneededSoftwares : Array(ISM::SoftwareInformation))
            tasks = <<-CODE
                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareFullVersionNames}

                    #LOADING TARGETS
                    #{getRequiredTargets(unneededSoftwares)}

                    puts

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSystemInformationFile
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

                        ISM::Core::Notification.startSoftwareUninstallingMessage(index, limit, port, name, version)

                        begin
                            target.uninstall
                        rescue exception
                            ISM::Core::Error.show(  className: "None",
                                                    functionName: "None",
                                                    errorTitle: "Uninstallation task failed",
                                                    error: "The current target uninstallation failed",
                                                    exception: exception)
                        end

                        ISM::Core::Notification.endSoftwareUninstallingMessage(index, limit, port, name, version)

                        if index < limit-1
                            ISM::Core::Notification.separator
                        end

                    end

                    CODE

            generateTasksFile(tasks)

            if Ism.settings.binaryTaskMode
                ISM::Core::Notification.taskCompilationTitleMessage
                buildTasksFile
                ISM::Core::Notification.calculationDoneMessage
            end

            runTasksFile

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "startUninstallationProcess",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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
            ISM::Core::Error.show(  className: "CommandLine",
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
                        ISM::Core::Notification.calculationDoneMessage
                        ISM::Core::Notification.unavailableDependencyMessage(softwares[0],softwares[1])

                        ISM::Core.exitProgram
                    end

                end

            end

            return dependencyHash

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
                                ISM::Core::Notification.calculationDoneMessage
                                ISM::Core::Notification.inextricableDependenciesMessage([calculatedDependencies[key1][0],calculatedDependencies[key2][0]])

                                ISM::Core.exitProgram
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getDependencyTable",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def getSortedDependencies(dependencyTable : Hash(String, Array(ISM::SoftwareInformation))) : Array(ISM::SoftwareInformation)

            result = dependencyTable.to_a.sort_by { |k, v| v.size }

            return result.map { |entry| entry[1][0]}

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getSortedDependencies",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def generateTasksFile(tasks : String)
            if !Dir.exists?("#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}")
                Dir.mkdir_p("#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}")
            end

            File.write("#{@settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::Task}.cr", tasks)

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
                ISM::Core::Notification.calculationDoneMessage
                ISM::Core::Notification.softwareNeededMessage(wrongArguments)
                #exitProgram
            end

            return unneededSoftwares

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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

            ISM::Core::Notification.calculationDoneMessage

            #IF THERE IS ANY SKIPPED UPDATES, WE NOTICE THE USER
            if skippedUpdates
                ISM::Core::Notification.skippedUpdatesMessage

                #Remove duplicate skipped updates
                @unavailableDependencySignals.uniq! { |entry| [entry[0].fullVersionName,entry[1].fullVersionName]}

                #Show all skipped updates
                @unavailableDependencySignals.each do |signal|
                    ISM::Core::Notification.unavailableDependencyMessage(signal[0], signal[1], allowTitle: false)
                end

            end

            #NEEDED to check if any of the updated software is a dependency of any required software for the system

            puts

            return softwareToUpdate

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "deletePatch",
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
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "getNeededKernelOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def generateDefaultKernelConfig
            requestedCommands = "make #{@settings.systemMakeOptions} defconfig"
            path = kernelSourcesPath

            ISM::Core.runSystemCommand(requestedCommands, path)

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
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

            ISM::Core.runSystemCommand(requestedCommands, path)

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "generateKernel",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def installKernel
            requestedCommands = "mv System.map /boot/System.map-linux-#{mainKernelVersion} && mv vmlinuz /boot/vmlinuz-linux-#{mainKernelVersion} && cp .config /boot/config-linux-#{mainKernelVersion}"
            path = kernelSourcesPath

            ISM::Core.runSystemCommand(requestedCommands, path)

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "installKernel",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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

            ISM::Core.runSystemCommand("./#{kernelSourcesPath}/config",arguments,"#{kernelSourcesPath}/scripts")

            rescue exception
            ISM::Core::Error.show(  className: "CommandLine",
                                    functionName: "setKernelOption",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

    end

end
