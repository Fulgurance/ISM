module ISM

    class CommandLine

        module Default

            Title = "Ingenius System Manager"
            Name = "ism"
            SystemCallErrorNotificationHelp = "ISM raised that error because the ran script did not call properly a system command or the system command itself need to be fix."
            TaskCompilationText = "Task compilation in process: "
            CompilationWaitingText = "Compiling the requested task"
            TaskCompilationFailedText = "Failed !"
            AmbiguousSearchTitle = "The searched software name is ambiguous."
            AmbiguousSearchText = "ISM is unable to find the requested software because there are multiple entry in the database for this name:"
            InextricableText = "ISM stopped due to an inextricable problem of dependencies with these softwares:"
            MissingSelectedDependenciesText = "ISM stopped due to missing unique dependencies not selected yet:"
            MissingSelectionText = "One of these unique dependencies need to be selected:"
            SkippedUpdatesText = "ISM will skip some updates due to missing dependencies:"
            UnconfiguredSystemComponentText1 = "The system component "
            UnconfiguredSystemComponentText2 = " is not configured yet. Operation aborted. Please set this component first."
            UnavailableText1 = "ISM stopped due to some missing dependencies for the requested softwares:"
            UnavailableText2 = " is missing for "
            NoUpdate = "System up to date."
            NoCleaningRequiredMessage = "No cleaning required. Task complete."
            CalculationTitle = "ISM start to calculate dependencies: "
            CalculationWaitingText = "Checking dependency tree"
            SynchronizationWaitingText = "Synchronization with the online database"
            CodependencyExtensionText = "Codependency"
            CalculationDoneText = "Done !"
            Separator = ">>>"
            NoOptionText = "no option"
            NewText = "New!"
            AdditionalVersionText = "Additional Version"
            UpdateText = "Update"
            BuildingPhaseText = "Building Phase"
            OptionUpdateText = "Option Update"
            RebuildText = "Rebuild"
            RebuildDueOfCodependencyText = "Rebuild due of codependency"
            InstallSummaryText = " new softwares will be install"
            InstallQuestion = "Would you like to install these softwares ?"
            UpdateSummaryText = " softwares will be build for the system update"
            UpdateQuestion = "Would you like to build these softwares ?"
            UninstallSummaryText = " softwares will be uninstall including unneeded dependencies"
            UninstallQuestion = "Would you like to uninstall these softwares ?"
            YesReplyOption = "yes"
            NoReplyOption = "no"
            YesShortReplyOption = "y"
            NoShortReplyOption = "n"
            InstallingText = "Installing"
            UninstallingText = "Uninstalling"
            InstallationDetailsText = "Installation Complete"
            NewSoftwareNumberDetailText = "New software number"
            NewDirectoryNumberDetailText = "New directory number"
            NewSymlinkNumberDetailText = "New symlink number"
            NewFileNumberDetailText = "New file number"
            InstalledSizeDetailText = "Total size"
            DoesntExistText = "Some requested softwares doesn't exist. Task cancelled."
            NoMatchFound = "No match found with the database for "
            NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
            SoftwareNotInstalled = "The following requested softwares are not installed yet: "
            NotInstalledText = "Some requested softwares are not installed. Task cancelled."
            NoVersionAvailable = "Some requested versions are not available: "
            NoVersionAvailableAdvice = "Maybe it's needed of refresh the database?"
            SoftwareNeeded = "The following requested softwares are required for the system: "
            NeededText = "Some requested softwares are actually needed. Task cancelled."
            InstalledText = "is installed"
            UninstalledText = "is uninstalled"

            Options = [ ISM::Option::Version.new,
                        ISM::Option::Software.new,
                        ISM::Option::System.new,
                        ISM::Option::Port.new,
                        ISM::Option::Settings.new,
                        ISM::Option::Tools.new]
        end

        property systemInformation : CommandLine::SystemInformation
        property requestedSoftwares : Array(Software::Information)
        property neededKernelOptions : Array(ISM::NeededKernelOption)
        property options : Array(CommandLine::Option)
        property settings : CommandLine::Settings
        property components : Array(Software::Information)
        property kernels : Array(ISM::AvailableKernel)
        property softwares : Array(ISM::AvailableSoftware)
        property installedSoftwares : Array(Software::Information)
        property ports : Array(ISM::Port)
        property mirrors : Array(ISM::Mirror)
        property mirrorsSettings : CommandLine::MirrorsSettings
        property favouriteGroups : Array(ISM::FavouriteGroup)
        property totalInstalledDirectoryNumber : UInt128
        property totalInstalledSymlinkNumber : UInt128
        property totalInstalledFileNumber : UInt128
        property totalInstalledSize : UInt128

        def initialize
            @systemInformation = CommandLine::SystemInformation.new
            @requestedSoftwares = Array(Software::Information).new
            @neededKernelOptions = Array(ISM::NeededKernelOption).new
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false
            @text = Default::CalculationWaitingText
            @options = Default::Options
            @settings = CommandLine::Settings.new
            @components = Array(Software::Information).new
            @kernels = Array(ISM::AvailableKernel).new
            @softwares = Array(ISM::AvailableSoftware).new
            @installedSoftwares = Array(Software::Information).new
            @ports = Array(ISM::Port).new
            @mirrors = Array(ISM::Mirror).new
            @mirrorsSettings = CommandLine::MirrorsSettings.new
            @favouriteGroups = Array(ISM::FavouriteGroup).new
            @initialTerminalTitle = String.new
            @unavailableDependencySignals = Array(Array(Software::Information)).new
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

        def start
            loadSettingsFiles
            loadSystemInformationFile
            loadBaseDirectories
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

        #This function ensure that the generated directory is owned by ism user:group
        def createSystemDirectory(path : String)
            Core::Security.runAsSuperUser {
                if !Dir.exists?(path)
                    Dir.mkdir_p(path)
                end

                #Special case: if we are doing cross compilation, we need to set all files and dirs as normal user/group
                if File.exists?(targetSystemInformationFilePath) && !targetSystemInformation.handleChroot && @settings.rootPath != "/" || !File.exists?(targetSystemInformationFilePath) && @settings.rootPath != "/"
                    splitPath = path.gsub(@settings.rootPath,"").split("/").reject { |entry| entry.empty?}

                    targetedPath = @settings.rootPath

                    splitPath.each do |dir|
                        targetedPath += "/#{dir}"

                        Core::Security.changeFileOwner( path: targetedPath,
                                                        user: Default::Name,
                                                        group: Default::Name)
                    end
                else
                    Core::Security.changeFileOwner( path: path,
                                                    user: Default::Name,
                                                    group: Default::Name)
                end
            }

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "createSystemDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to create system directory #{path}",
                                exception: exception)
        end

        def loadSettingsFiles
            settingsPath = "#{@settings.rootPath}#{Path::SettingsDirectory}"

            createSystemDirectory(settingsPath)

            @settings = CommandLine::Settings.loadConfiguration
            @mirrorsSettings = CommandLine::MirrorsSettings.loadConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadSettingsFiles",
                                errorTitle: "Execution failure",
                                error: "Failed to settings files from #{settingsPath}",
                                exception: exception)
        end

        def loadSystemInformationFile
            systemInformationPath = "#{@settings.rootPath}#{Path::SettingsDirectory}"

            createSystemDirectory(systemInformationPath)

            @systemInformation = CommandLine::SystemInformation.loadConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadSystemInformationFile",
                                errorTitle: "Execution failure",
                                error: "Failed to load system information file from #{systemInformationPath}",
                                exception: exception)
        end

        def loadBaseDirectories
            pathList = ["#{@settings.rootPath}#{Path::TemporaryDirectory}",
                        "#{@settings.rootPath}#{Path::LogsDirectory}",
                        "#{@settings.rootPath}#{Path::NeededKernelOptionsDirectory}",
                        "#{@settings.rootPath}#{Path::KernelOptionsDirectory}",
                        "#{@settings.rootPath}#{Path::SoftwaresDirectory}",
                        "#{@settings.rootPath}#{Path::PortsDirectory}",
                        "#{@settings.rootPath}#{Path::MirrorsDirectory}",
                        "#{@settings.rootPath}#{Path::FavouriteGroupsDirectory}",
                        "#{@settings.rootPath}#{Path::InstalledSoftwaresDirectory}"]

            pathList.each do |path|
                if !Dir.exists?(path)
                    createSystemDirectory(path)
                end
            end
        end

        def loadNeededKernelOptions
            path = @settings.rootPath+Path::NeededKernelOptionsDirectory

            neededKernelOptions = Dir.children(path)

            neededKernelOptions.each do |option|

                @neededKernelOptions << ISM::NeededKernelOption.loadConfiguration("#{path}/#{option}")

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadNeededKernelOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to load needed kernel option files from #{path}",
                                exception: exception)
        end

        def loadKernelOptionDatabase
            path = @settings.rootPath+Path::KernelOptionsDirectory

            availableKernels = Dir.children(path)

            availableKernels.each do |kernelDirectory|

                kernelOptionFiles = Dir.children("#{path}/#{kernelDirectory}")

                availableKernel = ISM::AvailableKernel.new(kernelDirectory)

                kernelOptionFiles.each do |kernelOptionFile|
                    availableKernel.options << ISM::KernelOption.loadConfiguration("#{path}/#{kernelDirectory}/#{kernelOptionFile}")
                end

                @kernels << availableKernel

            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadKernelOptionDatabase",
                                errorTitle: "Execution failure",
                                error: "Failed to load kernel option database from #{path}",
                                exception: exception)
        end

        def loadSoftware(port : String, name : String, version : String) : Software::Information
            software = Software::Information.loadConfiguration(  @settings.rootPath +
                                                                    Path::SoftwaresDirectory +
                                                                    port + "/" +
                                                                    name + "/" +
                                                                    version + "/" +
                                                                    Filename::Information)

            settingsFilePath = "#{@settings.rootPath}#{Path::SettingsSoftwaresDirectory}#{port}/#{name}/#{version}/#{Filename::SoftwareSettings}"

            if File.exists?(settingsFilePath)

                softwareSettings = Software::Information.loadConfiguration(settingsFilePath)

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
                                error: "Failed to load the software @#{port}:#{name}-#{version}",
                                exception: exception)
        end

        def loadSoftwareDatabase
            path = "#{@settings.rootPath}#{Path::SoftwaresDirectory}"

            portDirectories = Dir.children(path)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children("#{path}#{portDirectory}").reject!(&.starts_with?(".git"))

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children("#{path}#{portDirectory}/#{softwareDirectory}")
                    softwaresInformations = Array(Software::Information).new

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
                                error: "Failed to load software database from #{path}",
                                exception: exception)
        end

        def loadPortsDatabase
            path = "#{@settings.rootPath}#{Path::PortsDirectory}"

            portsFiles = Dir.children(path)

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
            path = "#{@settings.rootPath}#{Path::MirrorsDirectory}"

            mirrorsFiles = Dir.children(path)

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
            path = "#{@settings.rootPath}#{Path::FavouriteGroupsDirectory}"

            favouriteGroupsFiles = Dir.children(path)

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

        def loadInstalledSoftware(port : String, name : String, version : String) : Software::Information
            begin
                return Software::Information.loadConfiguration(  @settings.rootPath +
                                                                    Path::InstalledSoftwaresDirectory +
                                                                    port + "/" +
                                                                    name + "/" +
                                                                    version + "/" +
                                                                    Filename::Information)
            rescue
                return Software::Information.new
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "loadInstalledSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def loadInstalledSoftwareDatabase
            path = "#{@settings.rootPath}#{Path::InstalledSoftwaresDirectory}"

            portDirectories = Dir.children(path)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children("#{path}#{portDirectory}")

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children(  "#{path}#{portDirectory}/#{softwareDirectory}")

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

        def selectedKernel : Software::Information
            if File.exists?("#{Ism.settings.rootPath}#{Path::SettingsDirectory}#{Filename::SelectedKernel}")
                return Software::Information.loadConfiguration("#{Ism.settings.rootPath}#{Path::SettingsDirectory}#{Filename::SelectedKernel}")
            else
                return Software::Information.new
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "selectedKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def kernelIsSelected
            return selectedKernel.isValid

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "kernelIsSelected",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def reportMissingDependency(missingDependency : Software::Information, relatedSoftware : Software::Information)
            @unavailableDependencySignals.push([relatedSoftware, missingDependency])

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "reportMissingDependency",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def addInstalledSoftware(softwareInformation : Software::Information, installedFiles = Array(String).new)
            softwareInformation.installedFiles = installedFiles
            softwareInformation.writeConfiguration(softwareInformation.installedFilePath)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "addInstalledSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def addSoftwareToFavouriteGroup(fullVersionName : String, favouriteGroupName = FavouriteGroup::Default::Name)
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

        def removeSoftwareToFavouriteGroup(fullVersionName : String, favouriteGroupName = FavouriteGroup::Default::Name)
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

        #Uninstall one or more software. If multiple are uninstalled at the same time, will check if we need to preserve any file.
        def uninstallSoftwares(softwares : Array(Software::Information))

            if targetSystemInformation.handleChroot
                unlockSystemAccess
            end

            otherVersions = Array(Software::Information).new
            protectedFiles = Array(String).new
            filesForRemoval = Array(String).new
            softwareForRemovalArray = Array(Software::Information).new

            @installedSoftwares.each_with_index do |installedSoftware, index|

                if softwares.any? { |software| software.fullName == installedSoftware.fullName && !(software.hiddenName == installedSoftware.hiddenName)}
                    otherVersions.push(installedSoftware)
                end

            end

            protectedFiles = otherVersions.map { |version| version.installedFiles }.flatten.uniq
            installedFilesForRemoval = softwares.map { |software| software.installedFiles}.flatten.uniq

            if protectedFiles.size > 0
                protectedFiles.each do |file|

                    if !installedFilesForRemoval.includes?(file)
                        filesForRemoval.push(file)
                    end
                end
            else
                filesForRemoval = installedFilesForRemoval
            end

            Core::Security.runAsSuperUser {
                filesForRemoval.each do |file|
                    if File.exists?(Ism.settings.rootPath+file) || File.symlink?(Ism.settings.rootPath+file)
                        FileUtils.rm_r(Ism.settings.rootPath+file)
                    end
                end
            }

            softwares.each_with_index do |software, index|

                ISM::Core::Notification.uninstall(software)

                updateUninstallationTerminalTitle(  index,
                                                    softwares.size,
                                                    software.port,
                                                    software.name,
                                                    software.version)
                showStartSoftwareUninstallingMessage(   index,
                                                        softwares.size,
                                                        software.port,
                                                        software.name,
                                                        software.version)

                Core::Security.runAsSuperUser {
                    FileUtils.rm_r("#{software.installedDirectoryPath}/#{software.version}")

                    if Dir.empty?(software.installedDirectoryPath)
                        FileUtils.rm_r(software.installedDirectoryPath)
                    end
                }

                showEndSoftwareUninstallingMessage( index,
                                                    softwares.size,
                                                    software.port,
                                                    software.name,
                                                    software.version)

                if index < softwares.size-1
                    showSeparator
                end
            end

            if targetSystemInformation.handleChroot
                lockSystemAccess
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

        def softwareIsRequestedSoftware(software : Software::Information) : Bool
            return @requestedSoftwares.any? { |entry| entry.fullVersionName == software.fullVersionName}

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "softwareIsRequestedSoftware",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareIsInstalled(software : Software::Information) : Bool

            installedOne = Software::Information.new

            if File.exists?(software.installedFilePath)
                installedOne = Software::Information.loadConfiguration(software.installedFilePath)
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

        def softwaresAreCodependent(software1 : Software::Information, software2 : Software::Information) : Bool
            return software1.allowCodependencies.includes?(software2.fullName) && software2.allowCodependencies.includes?(software1.fullName) && !software1.passEnabled && !software2.passEnabled

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "softwaresAreCodependent",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getSoftwareStatus(software : Software::Information) : Symbol
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

        def getSoftwareInformation(userEntry : String, allowSearchByNameOnly = false, searchComponentsOnly = false) : Software::Information
            entry = String.new
            matches = Array(String).new
            result = Software::Information.new

            if allowSearchByNameOnly

                if searchComponentsOnly
                    #For now, by default, we can search only component by fullName or name, not by fullVersionName
                    @components.each do |component|
                        if component.name.downcase == userEntry.downcase
                            matches.push(component.fullName)
                        end
                    end

                else

                    #Check first if the user entry if by name only or version name, and if it is valid
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

            if entry == ""
                entry = userEntry
            end

            if searchComponentsOnly
                @components.each do |component|
                    if component.fullName.downcase == entry.downcase

                        return loadSoftware(component.port, component.name, component.version)

                    end
                end
            else
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

        def softwareIsGreatestVersion(information : Software::Information)
            @softwares.each do |availableSoftware|
                software = availableSoftware.greatestVersion

                if information.fullName == software.fullName && SemanticVersion.parse(information.version) >= SemanticVersion.parse(software.version)
                    return true
                end
            end

            return false
        end

        def checkEnteredArguments
            matchingOption = false

            terminalTitleArguments = (ARGV.empty? ? "" : ARGV.join(" "))
            setTerminalTitle("#{Default::Name} #{terminalTitleArguments}")

            if ARGV.empty?
                matchingOption = true
                ISM::Option::Help.new.start
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
                ISM::Core::Notification.unknownArgumentError
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "checkEnteredArguments",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def resetCalculationAnimation
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false
        end

        def playCalculationAnimation(@text = Default::CalculationWaitingText)
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

        def getRequestedSoftwares(list : Array(String), allowSearchByNameOnly = false) : Array(Software::Information)
            softwaresList = Array(Software::Information).new

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

        def showTaskBuildingProcessErrorMessage(error : String, path : String)
            ISM::Core::Notification.internalError(error: error, path: path)
        end

        def showNoMatchFoundMessage(wrongArguments : Array(String))
            puts Default::NoMatchFound + "#{wrongArguments.join(", ").colorize(:green)}"
            puts Default::NoMatchFoundAdvice
            puts
            puts "#{Default::DoesntExistText.colorize(:green)}"
        end

        def showSoftwareNotInstalledMessage(wrongArguments : Array(String))
            puts Default::SoftwareNotInstalled + "#{wrongArguments.join(", ").colorize(:green)}"
            puts
            puts "#{Default::NotInstalledText.colorize(:green)}"
        end

        def showNoVersionAvailableMessage(wrongArguments : Array(String))
            puts Default::NoVersionAvailable + "#{wrongArguments.join(", ").colorize(:green)}"
            puts Default::NoVersionAvailableAdvice
            puts
            puts "#{Default::DoesntExistText.colorize(:green)}"
        end


        def showNoUpdateMessage
            puts "#{Default::NoUpdate.colorize(:green)}"
        end

        def showNoCleaningRequiredMessage
            puts "#{Default::NoCleaningRequiredMessage.colorize(:green)}"
        end

        def showSoftwareNeededMessage(wrongArguments : Array(String))
            puts Default::SoftwareNeeded + "#{wrongArguments.join(", ").colorize(:green)}"
            puts
            puts "#{Default::NeededText.colorize(:green)}"
        end

        def showSkippedUpdatesMessage
            puts "#{Default::SkippedUpdatesText.colorize(:yellow)}"
            puts
        end

        def showUnconfiguredSystemComponentMessage(component : Software::Information)
            componentText = "#{("@"+component.port).colorize(:red)}:#{component.name.colorize(:green)}"

            puts
            puts "#{Default::UnconfiguredSystemComponentText1.colorize(:yellow)}#{componentText}#{Default::UnconfiguredSystemComponentText2.colorize(:yellow)}"
        end

        def showUnavailableDependencyMessage(software : Software::Information, dependency : Software::Information, allowTitle = true)
            puts

            if allowTitle
                puts "#{Default::UnavailableText1.colorize(:yellow)}"
                puts "\n"
            end

            dependencyText = "#{dependency.fullName.colorize(:magenta)}" + " /" + "#{dependency.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

            optionsText = "{ "

            if dependency.options.empty?
                optionsText += "#{"#{Default::NoOptionText} ".colorize(:dark_gray)}"
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

            missingDependencyText = "#{Default::UnavailableText2.colorize(:red)}"

            softwareText = "#{software.fullName.colorize(:green)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/"

            puts "\t" + dependencyText + optionsText + missingDependencyText + softwareText + "\n"

            if allowTitle
                puts "\n"
            end
        end

        def showAmbiguousSearchMessage(matches : Array(String))
            names = String.new

            puts
            puts "#{Default::AmbiguousSearchTitle.colorize(:yellow)}"
            puts "\n"

            matches.each_with_index do |name, index|
                names += "#{name.colorize(:red)}#{index < matches.size-1 ? ", " : "."}"
            end

            puts "#{Default::AmbiguousSearchText.colorize(:green)} #{names}"
        end

        def showInextricableDependenciesMessage(treeArrays : Array(Array(Software::Information)))
            dependencyChains = Array(Array(Software::Information)).new

                #TO DO ?
                dependencyChains = treeArrays

                puts
                puts "#{Default::InextricableText.colorize(:yellow)}"
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
                            optionsText += "#{"#{Default::NoOptionText} ".colorize(:dark_gray)}"
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
            puts "#{Default::MissingSelectedDependenciesText.colorize(:yellow)}"
            puts "\n"

            puts "#{fullName.colorize(:magenta)}" + " /" + "#{version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

            dependencySelection.each do |selection|
                dependencySet = selection.map { |entry| "#{(entry[0..entry.index(":")])[0..-2].colorize(:red)}:#{entry.gsub(entry[0..entry.index(":")],"").colorize(:green)}" }

                puts "\t#{Default::MissingSelectionText.colorize(:magenta)} #{dependencySet.join(" | ")}"
            end

            puts "\n"
        end

        def showTaskCompilationTitleMessage
            puts
            print "#{Default::TaskCompilationText}"
        end

        def showTaskCompilationFailedMessage
            cleanCalculationAnimation
            print "#{Default::TaskCompilationFailedText.colorize(Colorize::ColorRGB.new(255,100,100))}\n"
        end

        def showCalculationDoneMessage
            cleanCalculationAnimation
            print "#{Default::CalculationDoneText.colorize(:green)}\n"
        end

        def showCalculationTitleMessage
            puts
            print "#{Default::CalculationTitle}"
        end

        def showSoftwares(neededSoftwares : Array(Software::Information), mode = :installation)
            checkedSoftwares = Array(String).new

            puts "\n"

            neededSoftwares.each_with_index do |software, index|
                softwareText = "#{"@#{software.port}".colorize(:red)}:#{software.name.colorize(:green)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/"
                optionsText = "{ "

                if software.options.empty?
                    optionsText += "#{"#{Default::NoOptionText} ".colorize(:dark_gray)}"
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
                        additionalText += "#{Default::RebuildDueOfCodependencyText.colorize(:yellow)}"
                    else

                        status = getSoftwareStatus(software)

                        case status
                        when :new
                            additionalText += "#{Default::NewText.colorize(:yellow)}"
                        when :additionalVersion
                            additionalText += "#{Default::AdditionalVersionText.colorize(:yellow)}"
                        when :update
                            additionalText += "#{Default::UpdateText.colorize(:yellow)}"
                        when :buildingPhase
                            additionalText += "#{Default::BuildingPhaseText.colorize(:yellow)} #{software.getEnabledPassNumber.colorize(:yellow)}"
                        when :optionUpdate
                            additionalText += "#{Default::OptionUpdateText.colorize(:yellow)}"
                        when :rebuild
                            additionalText += "#{Default::RebuildText.colorize(:yellow)}"
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
            summaryText = softwareNumber.to_s + Default::InstallSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{Default::InstallQuestion}" +
                    "[" + "#{Default::YesReplyOption.colorize(:green)}" +
                    "/" + "#{Default::NoReplyOption.colorize(:red)}" + "]"
        end

        def showUninstallationQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + Default::UninstallSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{Default::UninstallQuestion.colorize}" +
                    "[" + "#{Default::YesReplyOption.colorize(:green)}" +
                    "/" + "#{Default::NoReplyOption.colorize(:red)}" + "]"
        end

        def showUpdateQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + Default::UpdateSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{Default::UpdateQuestion.colorize.mode(:underline)}" +
                    "[" + "#{Default::YesReplyOption.colorize(:green)}" +
                    "/" + "#{Default::NoReplyOption.colorize(:red)}" + "]"
        end

        def getUserAgreement : Bool

            loop do
                userInput = gets.to_s

                if userInput.downcase == Default::YesReplyOption.downcase || userInput.downcase == Default::YesShortReplyOption.downcase
                    return true
                elsif userInput.downcase == Default::NoReplyOption.downcase || userInput.downcase == Default::NoShortReplyOption.downcase
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
            setTerminalTitle("#{Default::Name} [#{(index+1)} / #{limit}]: #{Default::InstallingText} @#{port}:#{name}#{passNumber == 0 ? "" : " (Pass#{passNumber})"} /#{version}/")

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "updateInstallationTerminalTitle",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def updateUninstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String)
            setTerminalTitle("#{Default::Name} [#{(index+1)} / #{limit}]: #{Default::UninstallingText} @#{port}:#{name} /#{version}/")

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "updateUninstallationTerminalTitle",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def cleanBuildingDirectory(path : String)

            Core::Security.runAsSuperUser {
                if Dir.exists?(path)
                    FileUtils.rm_r(path)
                end
            }

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
            puts "#{Default::Separator.colorize(:green)}\n"
            puts "\n"
        end

        def showEndSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
            puts
            puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)}#{passNumber == 0 ? "" : " (Pass#{passNumber})".colorize(:yellow)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    " #{Default::InstalledText} " +
                    "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                    "#{">>".colorize(:light_magenta)}" +
                    "\n"
        end

        def showEndSoftwareUninstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
            puts
            puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    " #{Default::UninstalledText} " +
                    "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                    "#{">>".colorize(:light_magenta)}" +
                    "\n"
        end

        def showInstallationDetailsMessage(softwareNumber : UInt32)
            title = Default::InstallationDetailsText

            puts    "\n[ #{title.colorize(:green)} ]\n\n" +
                    "#{Default::NewSoftwareNumberDetailText.colorize(:green)}: #{softwareNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{Default::NewDirectoryNumberDetailText.colorize(:green)}: #{@totalInstalledDirectoryNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{Default::NewSymlinkNumberDetailText.colorize(:green)}: #{@totalInstalledSymlinkNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{Default::NewFileNumberDetailText.colorize(:green)}: #{@totalInstalledFileNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                    "#{Default::InstalledSizeDetailText.colorize(:green)}: #{@totalInstalledSize.humanize_bytes.colorize(Colorize::ColorRGB.new(255,100,100))}\n\n"
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
            requireFileContent = File.read_lines("/#{Path::LibraryDirectory}#{Filename::RequiredLibraries}")
            requiredLibraries = String.new

            requireFileContent.each do |line|
                if line.includes?("require \".")
                    newLine = line.gsub("require \".","{{ read_file(\"/#{Path::LibraryDirectory}")+"\n"
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

        def getRequiredTargets(neededSoftwares : Array(Software::Information)) : String
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
                        requiredTargetArrayResult += "\t\t\tTarget#{index}.new(\"#{software.filePath}\"),\n"
                    else
                        requiredTargetArrayResult += "\t\t\tTarget#{index}.new(\"#{software.filePath}\")]\n"
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
                            indexResult += "\t\t\t#{index}"
                        else
                            indexResult += "\t\t\t#{index}"
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
                    "#END TARGET SECTION\n" +
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

        def startInstallationProcess(neededSoftwares : Array(Software::Information))
            tasks = <<-CODE
                    puts

                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareFullVersionNames}

                    #LOADING TARGETS, ADDITIONAL INFORMATION INDEX AND NEEDED OPTIONS
                    #{getRequiredTargets(neededSoftwares)}

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadBaseDirectories
                    Ism.loadSoftwareDatabase
                    Ism.requestedSoftwares = requestedSoftwareFullVersionNames.map { |entry| Ism.getSoftwareInformation(entry)}

                    limit = targets.size

                    targets.each_with_index do |target, index|
                        Ism.loadSystemInformationFile

                        information = target.information
                        port = information.port
                        name = information.name
                        version = information.version
                        passNumber = information.getEnabledPassNumber
                        fullVersionName = information.fullVersionName
                        builtSoftwareDirectoryPath = \"#\{Ism.settings.rootPath\}#\{ISM::Path::BuiltSoftwaresDirectory\}#\{information.port\}/#\{information.name\}/\"
                        colouredFullVersionName = \"#\{information.fullName.colorize(:magenta)} /#\{version.colorize(Colorize::ColorRGB.new(255,100,100))}/\"

                        #START INSTALLATION PROCESS

                        Ism.updateInstallationTerminalTitle(index, limit, port, name, version, passNumber)

                        Ism.showStartSoftwareInstallingMessage(index, limit, port, name, version, passNumber)

                        Ism.cleanBuildingDirectory(builtSoftwareDirectoryPath)

                        #Setup
                        begin
                            target.setup
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "setup",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"setup".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.download
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "download",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"download".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.check
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "check",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"check".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.extract
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "extract",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"extract".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.patch
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "patch",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"patch".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.prepare
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "prepare",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"prepare".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.configure
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "configure",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"configure".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.build
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "build",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"build".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.prepareInstallation
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "prepareInstallation",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"prepareInstallation".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            directoryNumber, symlinkNumber, fileNumber, totalSize = target.recordInstallationInformation
                            Ism.recordInstallationDetails(directoryNumber, symlinkNumber, fileNumber, totalSize)
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "recordInstallationInformation",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"recordInstallationInformation".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.install
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "install",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"install".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.recordNeededKernelOptions
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "recordNeededKernelOptions",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"recordNeededKernelOptions".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        begin
                            target.clean
                        rescue exception
                            ISM::Error.show(className: "Software<|#\{information.colouredFullVersionName}|>",
                                            functionName: "clean",
                                            errorTitle: "Installation task failed",
                                            error: "The #\{"clean".colorize(:magenta)} process failed for #\{colouredFullVersionName}",
                                            exception: exception)
                        end

                        #Update the ISM instance to make sure the database is up to date and avoiding to reload everything
                        Ism.installedSoftwares.push(target.information)

                        Ism.cleanBuildingDirectory(builtSoftwareDirectoryPath)

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

            showTaskCompilationTitleMessage
            buildTasksFile
            showCalculationDoneMessage

            runTasksFile(logEnabled: true, softwareList: neededSoftwares)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "startInstallationProcess",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def buildTasksFile
            if File.exists?("#{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}")
                Core::Security.runAsSuperUser {
                    Process.run(command: "/usr/bin/chattr -f -i #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}",
                                shell: true)

                    Process.run(command: "/usr/bin/rm #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}",
                                shell: true)
                }
            end

            processResult = IO::Memory.new

            Process.run("CRYSTAL_WORKERS=#{Ism.settings.makeOptions[2..-1]} crystal build #{Filename::Task}.cr -o #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}",
                        error: processResult,
                        shell: true,
                        chdir: "#{@settings.rootPath}#{Path::RuntimeDataDirectory}") do |process|
                loop do
                    playCalculationAnimation(Default::CompilationWaitingText)
                    Fiber.yield
                    break if process.terminated?
                end
            end

            processResult.rewind

            if processResult.to_s != ""
                showTaskCompilationFailedMessage
                showTaskBuildingProcessErrorMessage(error: processResult.to_s,
                                                    path: "#{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr")
                exitProgram(code: 1)
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "buildTasksFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def runTasksFile(logEnabled = false, softwareList = Array(Software::Information).new)
            # We first set proper rights for the binary and task file:
            #   -owned by root (uid 0 and gid 0)
            #   -suid bit set
            #   -set as immutable to don't allow any suppression
            Core::Security.runAsSuperUser {
                Process.run(command: "/usr/bin/chown 0:0 #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}",
                            shell: true)

                Process.run(command: "/usr/bin/chmod ugo+s #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}",
                            shell: true)

                Process.run(command: "/usr/bin/chattr -f +i #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}",
                            shell: true)

                Process.run(command: "/usr/bin/chown 0:0 #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr",
                            shell: true)

                Process.run(command: "/usr/bin/chattr -f +i #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr",
                            shell: true)
            }

            command = "./#{Filename::Task}"

            logIOMemory = IO::Memory.new

            logWriter = logEnabled ? IO::MultiWriter.new(STDOUT,logIOMemory) : Process::Redirect::Inherit

            process = Process.run(  command: command,
                                    output: logWriter,
                                    error: logWriter,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{Path::RuntimeDataDirectory}")

            if logEnabled

                logs = logIOMemory.to_s.split("#{Default::Separator.colorize(:green)}\n")

                logs.each_with_index do |log, index|

                    createSystemDirectory("#{@settings.rootPath}#{Path::LogsDirectory}#{softwareList[index].port}")
                    File.write("#{@settings.rootPath}#{Path::LogsDirectory}#{softwareList[index].port}/#{softwareList[index].versionName}.log", log)

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

        def showStartSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
            puts    "#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{Default::InstallingText} " +
                    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)}#{passNumber == 0 ? "" : " (Pass#{passNumber})".colorize(:yellow)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    "\n\n"
        end

        def showStartSoftwareUninstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
            puts    "\n#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{Default::UninstallingText} " +
                    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    "\n\n"
        end

        def synchronizePorts
            @ports.each do |port|

                synchronization = port.synchronize

                until synchronization.terminated?
                    playCalculationAnimation(Default::SynchronizationWaitingText)
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

        def getRequiredDependencies(softwares : Array(Software::Information), allowRebuild = false, allowDeepSearch = false, allowSkipUnavailable = false, skipSystemComponents = false) : Hash(String, Software::Information)

            dependencyHash = Hash(String, Software::Information).new
            currentDependencies = softwares.map { |entry| entry.toSoftwareDependency}
            nextDependencies = Array(Software::Dependency).new
            invalidDependencies = Array(Software::Information).new

            if !skipSystemComponents
                @components.each do |component|
                    if !component.isConfigured
                        showCalculationDoneMessage
                        showUnconfiguredSystemComponentMessage(component)
                        exitProgram
                    end
                end
            end

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

                            invalidDependencies.push(Software::Information.new(port: dependency.port, name: dependency.name, version: dependency.requiredVersion))

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

                    return Hash(String, Software::Information).new

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

        def getDependencyTree(software : Software::Information, softwareList : Hash(String, Software::Information), calculatedDependencies = Hash(String, Array(Software::Information)).new) : Array(Software::Information)

            dependencies = Hash(String, Software::Information).new

            currentDependencies = [software.toSoftwareDependency]
            nextDependencies = Array(Software::Dependency).new

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

        def getDependencyTable(softwareList : Hash(String, Software::Information)) : Hash(String, Array(Software::Information))

            calculatedDependencies = Hash(String, Array(Software::Information)).new

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
                                if !key1.includes?("-#{Default::CodependencyExtensionText}") && !key2.includes?("-#{Default::CodependencyExtensionText}") && !calculatedDependencies.has_key?(key1+"-#{Default::CodependencyExtensionText}") && !calculatedDependencies.has_key?(key2+"-#{Default::CodependencyExtensionText}")

                                    #RELATED TO OPTION OR DIRECT DEPENDENCY ?
                                    key1HaveOptionalCodependency = calculatedDependencies[key1][0].option(calculatedDependencies[key2][0].name)
                                    key2HaveOptionalCodependency = calculatedDependencies[key2][0].option(calculatedDependencies[key1][0].name)

                                    #--------------------------------------------------------------------
                                    if key1HaveOptionalCodependency
                                        calculatedDependencies[key1+"-#{Default::CodependencyExtensionText}"] = calculatedDependencies[key1].clone

                                        calculatedDependencies[key1+"-#{Default::CodependencyExtensionText}"].each do |dependency|
                                            playCalculationAnimation

                                            if dependency.hiddenName == key2
                                                calculatedDependencies[key1].delete(dependency)
                                            end
                                        end

                                        calculatedDependencies[key1+"-#{Default::CodependencyExtensionText}"][0].options.each do |option|
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

                                        calculatedDependencies[key2+"-#{Default::CodependencyExtensionText}"] = calculatedDependencies[key2].clone

                                        calculatedDependencies[key2+"-#{Default::CodependencyExtensionText}"].each do |dependency|
                                            playCalculationAnimation

                                            if dependency.hiddenName == key1
                                                calculatedDependencies[key2].delete(dependency)
                                            end
                                        end

                                        calculatedDependencies[key2+"-#{Default::CodependencyExtensionText}"][0].options.each do |option|
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

        def getSortedDependencies(dependencyTable : Hash(String, Array(Software::Information))) : Array(Software::Information)

            result = dependencyTable.to_a.sort_by { |k, v| v.size }

            return result.map { |entry| entry[1][0] }

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getSortedDependencies",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def generateTasksFile(tasks : String)
            if !Dir.exists?("#{@settings.rootPath}#{Path::RuntimeDataDirectory}")
                Dir.mkdir_p("#{@settings.rootPath}#{Path::RuntimeDataDirectory}")
            end

            if File.exists?("#{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr")
                Core::Security.runAsSuperUser {
                    Process.run(command: "/usr/bin/chattr -f -i #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr",
                                shell: true)

                    Process.run(command: "/usr/bin/rm #{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr",
                                shell: true)
                }
            end

            File.write("#{@settings.rootPath}#{Path::RuntimeDataDirectory}#{Filename::Task}.cr", tasks)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "generateTasksFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getNeededSoftwares : Array(Software::Information)
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

        def getUnneededSoftwares : Array(Software::Information)
            wrongArguments = Array(String).new
            requiredSoftwares = Hash(String,Software::Information).new
            unneededSoftwares = Array(Software::Information).new
            softwareList = Array(String).new
            softwareInformationList = Array(Software::Information).new

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
            requiredSoftwares = getRequiredDependencies(softwareInformationList, allowDeepSearch: true, skipSystemComponents: false)

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

        def getSoftwaresToUpdate : Array(Software::Information)
            softwareToUpdate = Array(Software::Information).new
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
            if !Dir.exists?(@settings.rootPath+Path::PatchesDirectory+"/#{softwareVersionName}")
                Dir.mkdir_p(@settings.rootPath+Path::PatchesDirectory+"/#{softwareVersionName}")
            end

            patchFileName = path.lchop(path[0..path.rindex("/")])

            begin
                FileUtils.cp(   path,
                                @settings.rootPath+Path::PatchesDirectory+"/#{softwareVersionName}/#{patchFileName}")
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
            path = @settings.rootPath+Path::PatchesDirectory+"/#{softwareVersionName}/#{patchName}"

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
            root = ((targetSystemInformation.handleChroot || !targetSystemInformation.handleChroot && @settings.rootPath != "/") ? "/" : @settings.rootPath)

            return "#{root}#{Path::TemporaryDirectory}"
        end

        #Relative to chroot
        def taskRelativeFilePath : String
            return "#{taskRelativeDirectoryPath}#{Filename::Task}"
        end

        def taskAbsoluteDirectoryPath : String
            return "#{@settings.rootPath}#{Path::TemporaryDirectory}"
        end

        def taskAbsoluteFilePath : String
            return "#{taskAbsoluteDirectoryPath}#{Filename::Task}"
        end

        def hostSystemInformationFilePath : String
            return "/#{CommandLine::SystemInformation::Default::SystemInformationFilePath}"
        end

        def hostSystemInformation : CommandLine::SystemInformation
            return CommandLine::SystemInformation.loadConfiguration(hostSystemInformationFilePath)
        end

        def targetSystemInformationFilePath : String
            return "#{@settings.rootPath}#{CommandLine::SystemInformation::Default::SystemInformationFilePath}"
        end

        def targetSystemInformation : CommandLine::SystemInformation
            return CommandLine::SystemInformation.loadConfiguration(targetSystemInformationFilePath)
        end

        def runTasks(   tasks : String,
                        asRoot = false,
                        viaChroot = false,
                        quiet = false,
                        input = Process::Redirect::Inherit,
                        output = Process::Redirect::Inherit,
                        error = Process::Redirect::Inherit) : Process::Status

            # We first check if there is any task left
            if File.exists?("#{taskAbsoluteFilePath}")
                process = Core::Security.runAsSuperUser {
                    Process.run(command: "rm #{taskAbsoluteFilePath}",
                                shell: true)
                }
            end

            if !Dir.exists?(taskAbsoluteDirectoryPath)
                Dir.mkdir_p(taskAbsoluteDirectoryPath)
            end

            File.write(taskAbsoluteFilePath, tasks)

            process = Core::Security.runAsSuperUser {
                Process.run(command:    "chmod +x #{taskAbsoluteFilePath}",
                            input: (quiet ? Process::Redirect::Close : input),
                            output: (quiet ? Process::Redirect::Close : output),
                            error: (quiet ? Process::Redirect::Close : error),
                            shell:      true)
            }

            if viaChroot
                user = (asRoot ? "0" : Core::Security::Default::Id.to_s)
                userspec = "--userspec=#{user}:#{user}"

                command = "HOME=/var/lib/ism chroot #{userspec} #{@settings.rootPath} #{taskRelativeFilePath}"
            else
                command = "#{taskAbsoluteFilePath}"
            end

            process = Core::Security.runAsSuperUser(validCondition: (viaChroot || asRoot)) {
                Process.run(command:    command,
                            input: (quiet ? Process::Redirect::Close : input),
                            output: (quiet ? Process::Redirect::Close : output),
                            error: (quiet ? Process::Redirect::Close : error),
                            shell:      true)
            }

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

        def runSystemCommand(   command : String | Array(String),
                                path = "/", environment = Hash(String, String).new,
                                environmentFilePath = String.new,
                                quiet = false,
                                asRoot = false,
                                viaChroot = true,
                                input = Process::Redirect::Inherit,
                                output = Process::Redirect::Inherit,
                                error = Process::Redirect::Inherit) : Process::Status

            rootMode = false

            environmentCommand = String.new
            profile = String.new
            requestedCommands = String.new

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

            if command.is_a?(String)
                requestedCommands = "cd #{path} && HOME=/var/lib/ism #{environmentCommand} #{command}"
            else
                requestedCommands = command.map { |entry| "cd #{path} && HOME=/var/lib/ism #{environmentCommand} #{entry}"}.join("\n")
            end

            tasks = <<-TASKS
            #!/bin/bash

            #{profile}

            #{requestedCommands}
            TASKS

            process = runTasks( tasks: tasks,
                                asRoot: rootMode,
                                viaChroot: targetSystemInformation.handleChroot && viaChroot && @settings.rootPath != "/",
                                quiet: quiet,
                                input: (quiet ? Process::Redirect::Close : input),
                                output: (quiet ? Process::Redirect::Close : output),
                                error: (quiet ? Process::Redirect::Close : error))

            #TRACELOG-------------------------------------------------------------
            ISM::TraceLog.record(   accessor:   "CommandLine",
                                    function:   "runSystemCommand",
                                    message:    <<-TEXT
                                    Running command:
                                    #{tasks}
                                    asRoot: #{rootMode}
                                    viaChroot: #{targetSystemInformation.handleChroot && viaChroot}
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
                ISM::Core::Notification.runSystemCommandError(requestedCommands, path, environment, environmentFilePath)
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
            standardOptions = Hash(String,ISM::NeededKernelOption).new
            specialOptions = Hash(String,ISM::NeededKernelOption).new

            #@neededKernelOptions
            #Create first a big array of all required options ?
            #To improve speed, pre record all option in a hash ?

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "getNeededKernelOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def cleanKernelSources
            requestedCommands = "make #{@settings.makeOptions} mrproper"
            path = kernelSourcesPath

            process = runSystemCommand( command: requestedCommands,
                                        asRoot: true,
                                        path: path)

            if !process.success?
                ISM::Core::Notification.runSystemCommandError(requestedCommands, path)
                exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "cleanKernelSources",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Build by default all modules. Will change in the future
        def generateKernelConfiguration
            requestedCommands = "make #{@settings.makeOptions} allmodconfig"
            path = kernelSourcesPath

            process = runSystemCommand( command: requestedCommands,
                                        asRoot: true,
                                        path: path)

            if !process.success?
                ISM::Core::Notification.runSystemCommandError(requestedCommands, path)
                exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "generateDefaultKernelConfig",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def buildKernel
            requestedCommands = "make #{@settings.makeOptions} modules_prepare && make #{@settings.makeOptions} && make #{@settings.makeOptions} modules_install && make #{@settings.makeOptions} install"
            path = kernelSourcesPath

            process = runSystemCommand( command: requestedCommands,
                                        asRoot: true,
                                        path: path)

            if !process.success?
                ISM::Core::Notification.runSystemCommandError(requestedCommands, path)
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
            root = (@systemInformation.handleChroot && @settings.rootPath != "/" ? "/" : @settings.rootPath)
            requestedCommands = "mv System.map #{root}boot/System.map-linux-#{mainKernelVersion} && mv vmlinux #{root}boot/vmlinuz-linux-#{mainKernelVersion} && cp .config #{root}boot/config-linux-#{mainKernelVersion}"
            path = kernelSourcesPath

            process = runSystemCommand( command: requestedCommands,
                                        asRoot: true,
                                        path: path)

            if !process.success?
                ISM::Core::Notification.runSystemCommandError(requestedCommands, path)
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
            return "#{@settings.rootPath}/usr/src/#{mainKernelName}/"
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

        def setLibSystemAccess(locked : Bool)
            mode = (locked ? "+" : "-")
            target = "usr/lib64"

            command = "/usr/bin/chattr -R -f #{mode}i #{@settings.rootPath}#{target}"

            process = runSystemCommand( command: command,
                                        asRoot: true,
                                        viaChroot: false)

            if !process.success? && process.exit_code != 1
                ISM::Error.show(className: "CommandLine",
                                functionName: "setLibSystemAccess",
                                errorTitle: "Failed to set the system access for /#{target}",
                                error: "An error occured while trying to modify the system access")
            end
        end

        def setBinSystemAccess(locked : Bool)
            mode = (locked ? "+" : "-")
            target = "usr/bin"

            command = "/usr/bin/chattr -R -f #{mode}i #{@settings.rootPath}#{target}"

            process = runSystemCommand( command: command,
                                        asRoot: true,
                                        viaChroot: false)

            if !process.success? && process.exit_code != 1
                ISM::Error.show(className: "CommandLine",
                                functionName: "setBinSystemAccess",
                                errorTitle: "Failed to set the system access for /#{target}",
                                error: "An error occured while trying to modify the system access")
            end
        end

        def setSbinSystemAccess(locked : Bool)
            mode = (locked ? "+" : "-")
            target = "usr/sbin"

            command = "/usr/bin/chattr -R -f #{mode}i #{@settings.rootPath}#{target}"

            process = runSystemCommand( command: command,
                                        asRoot: true,
                                        viaChroot: false)

            if !process.success? && process.exit_code != 1
                ISM::Error.show(className: "CommandLine",
                                functionName: "setSbinSystemAccess",
                                errorTitle: "Failed to set the system access for /#{target}",
                                error: "An error occured while trying to modify the system access")
            end
        end

        def setLibexecSystemAccess(locked : Bool)
            mode = (locked ? "+" : "-")
            target = "usr/libexec"

            command = "/usr/bin/chattr -R -f #{mode}i #{@settings.rootPath}#{target}"

            process = runSystemCommand( command: command,
                                        asRoot: true,
                                        viaChroot: false)

            if !process.success? && process.exit_code != 1
                ISM::Error.show(className: "CommandLine",
                                functionName: "setLibexecSystemAccess",
                                errorTitle: "Failed to set the system access for /#{target}",
                                error: "An error occured while trying to modify the system access")
            end
        end

        def setSystemAccess(locked : Bool)

            setLibSystemAccess(locked)
            setBinSystemAccess(locked)
            setSbinSystemAccess(locked)
            setLibexecSystemAccess(locked)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "setSystemAccess",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def lockSystemAccess
            setSystemAccess(locked: true)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "lockSystemAccess",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def unlockSystemAccess
            setSystemAccess(locked: false)

            rescue exception
                ISM::Error.show(className: "CommandLine",
                                functionName: "unlockSystemAccess",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
