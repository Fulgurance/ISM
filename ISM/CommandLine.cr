module ISM

    class CommandLine

        property requestedSoftwares : Array(ISM::SoftwareInformation)
        property softwaresNeedRebuild : Array(ISM::SoftwareInformation)
        property neededKernelFeatures : Array(String)
        property unneededKernelFeatures : Array(String)
        property debugLevel : Int32
        property options : Array(ISM::CommandLineOption)
        property settings : ISM::CommandLineSettings
        property kernels : Array(ISM::AvailableKernel)
        property softwares : Array(ISM::AvailableSoftware)
        property installedSoftwares : Array(ISM::SoftwareInformation)
        property ports : Array(ISM::Port)
        property portsSettings : ISM::CommandLinePortsSettings
        property mirrors : Array(ISM::Mirror)
        property mirrorsSettings : ISM::CommandLineMirrorsSettings
        property favouriteGroups : Array(ISM::FavouriteGroup)

        def initialize
            @requestedSoftwares = Array(ISM::SoftwareInformation).new
            @softwaresNeedRebuild = Array(ISM::SoftwareInformation).new
            @neededKernelFeatures = Array(String).new
            @unneededKernelFeatures = Array(String).new
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false
            @text = ISM::Default::CommandLine::CalculationWaitingText
            @debugLevel = ISM::Default::CommandLine::DebugLevel
            @options = ISM::Default::CommandLine::Options
            @settings = ISM::CommandLineSettings.new
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
        end

        def ranAsSuperUser : Bool
            return (LibC.getuid == 0)
        end

        def secureModeEnabled
            return @settings.secureMode
        end

        def start
            loadSettingsFiles
            loadKernelOptionDatabase
            loadSoftwareDatabase
            loadInstalledSoftwareDatabase
            loadPortsDatabase
            loadMirrorsDatabase
            loadFavouriteGroupsDatabase
            checkEnteredArguments
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
                    kernelOption = ISM::KernelOption.new
                    kernelOption.loadInformationFile(@settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+"/"+kernelDirectory+"/"+kernelOptionFile)

                    availableKernel.options << kernelOption
                end

                @kernels << availableKernel

            end
        end

        def loadSoftware(port : String, name : String, version : String) : ISM::SoftwareInformation
            software = ISM::SoftwareInformation.new

            software.loadInformationFile(   @settings.rootPath +
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

                softwareSettings = ISM::SoftwareInformation.new
                softwareSettings.loadInformationFile(   @settings.rootPath +
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

                        softwaresInformations << loadSoftware(portDirectory,softwareDirectory,versionDirectory)

                    end

                    @softwares << ISM::AvailableSoftware.new(softwareDirectory,softwaresInformations)

                end

            end

        end

        def loadPortsDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::PortsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::PortsDirectory)
            end

            portsFiles = Dir.children(@settings.rootPath+ISM::Default::Path::PortsDirectory)

            portsFiles.each do |portFile|
                port = ISM::Port.new(portFile[0..-6])
                port.loadPortFile
                @ports << port
            end
        end

        def loadMirrorsDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::MirrorsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::MirrorsDirectory)
            end

            mirrorsFiles = Dir.children(@settings.rootPath+ISM::Default::Path::MirrorsDirectory)

            if mirrorsFiles.size == 0
                mirror = ISM::Mirror.new
                mirror.loadMirrorFile
                @mirrors << mirror
            else
                mirrorsFiles.each do |mirrorFile|
                    mirror = ISM::Mirror.new(mirrorFile[0..-6])
                    mirror.loadMirrorFile
                    @mirrors << mirror
                end
            end
        end

        def loadFavouriteGroupsDatabase
            if !Dir.exists?(@settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)
                Dir.mkdir_p(@settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)
            end

            favouriteGroupsFiles = Dir.children(@settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)

            if favouriteGroupsFiles.size == 0
                favouriteGroup = ISM::FavouriteGroup.new
                favouriteGroup.loadFavouriteGroupFile
                @favouriteGroups << favouriteGroup
            else
                favouriteGroupsFiles.each do |favouriteGroupFile|
                    favouriteGroup = ISM::FavouriteGroup.new(favouriteGroupFile[0..-6])
                    favouriteGroup.loadFavouriteGroupFile
                    @favouriteGroups << favouriteGroup
                end
            end
        end

        def loadSettingsFiles
            @settings.loadSettingsFile
            @portsSettings.loadPortsSettingsFile
            @mirrorsSettings.loadMirrorsSettingsFile
        end

        def loadInstalledSoftware(port : String, name : String, version : String) : ISM::SoftwareInformation
            installedSoftware = ISM::SoftwareInformation.new

            begin
                installedSoftware.loadInformationFile(  @settings.rootPath +
                                                        ISM::Default::Path::InstalledSoftwaresDirectory +
                                                        port + "/" +
                                                        name + "/" +
                                                        version + "/" +
                                                        ISM::Default::Filename::Information)
            rescue
            end

            return installedSoftware
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
        end

        def inputMatchWithFilter(input : String, filter : Regex | Array(Regex))
            if filter.is_a?(Array(Regex))
                userInput = input.split(" ")

                userInput.each do |value|

                    if !filter.any? {|rule| rule.match(value) != nil}
                        return false,value
                    end

                end
            else
                if filter.match(input) == nil
                    return false,input
                end
            end

            return true,String.new
        end

        def addInstalledSoftware(softwareInformation : ISM::SoftwareInformation, installedFiles = Array(String).new)
            softwareInformation.installedFiles = installedFiles

            softwareInformation.writeInformationFile(softwareInformation.installedFilePath)
        end

        def addSoftwareToFavouriteGroup(versionName : String, favouriteGroupName = ISM::Default::FavouriteGroup::Name)
            favouriteGroup = ISM::FavouriteGroup.new(favouriteGroupName)
            favouriteGroup.loadFavouriteGroupFile
            favouriteGroup.softwares = favouriteGroup.softwares | [versionName]
            favouriteGroup.writeFavouriteGroupFile
        end

        def removeSoftwareToFavouriteGroup(versionName : String, favouriteGroupName = ISM::Default::FavouriteGroup::Name)
            #Ne pas créer si groupe n'existe pas
            favouriteGroup = ISM::FavouriteGroup.new(favouriteGroupName)
            favouriteGroup.loadFavouriteGroupFile
            favouriteGroup.softwares.delete(versionName)
            favouriteGroup.writeFavouriteGroupFile
        end

        def removeInstalledSoftware(software : ISM::SoftwareInformation)

            requestedVersion = ISM::SoftwareInformation.new
            otherVersions = Array(ISM::SoftwareInformation).new
            protectedFiles = Array(String).new
            filesForRemoval = Array(String).new


            @installedSoftwares.each do |installedSoftware|
                if software.hiddenName == installedSoftware.hiddenName
                    requestedVersion = installedSoftware
                else
                    if software.name == installedSoftware.name
                        otherVersions.push(installedSoftware)
                    end
                end
            end

            if requestedVersion.name != ""

                protectedFiles = otherVersions.map {|version| version.installedFiles }.flatten.uniq

                protectedFiles.each do |file|

                    if !requestedVersion.installedFiles.includes?(file)
                        filesForRemoval.push(file)
                    end
                end

                filesForRemoval.each do |file|
                    FileUtils.rm_r(@settings.rootPath+file)
                end

                FileUtils.rm_r(software.installedDirectoryPath)
            end
        end

        def softwareAnyVersionInstalled(softwareName : String) : Bool

            @installedSoftwares.each do |installedSoftware|

                if softwareName == installedSoftware.name && !installedSoftware.passEnabled
                    return true
                end

            end

            return false
        end

        def softwareIsRequestedSoftware(software : ISM::SoftwareInformation) : Bool
            return @requestedSoftwares.any? { |entry| entry.versionName == software.versionName}
        end

        def softwareIsInstalled(software : ISM::SoftwareInformation) : Bool

            if File.exists?(software.installedFilePath)
                installedSoftware = ISM::SoftwareInformation.new
                installedSoftware.loadInformationFile(software.installedFilePath)

                equalScore = 0

                software.options.each do |option|

                    if installedSoftware.option(option.name) == option.active
                        equalScore += 1
                    elsif option.isPass
                        softwarePassNumber = software.getEnabledPassNumber
                        installedSoftwarePassNumber = installedSoftware.getEnabledPassNumber

                        if option.active
                            if !installedSoftware.passEnabled
                                equalScore += 1
                            else
                                if softwarePassNumber < installedSoftwarePassNumber
                                    equalScore += 1
                                else
                                    return false
                                end
                            end
                        end

                        if installedSoftware.option(option.name)
                            if !installedSoftware.passEnabled
                                return false
                            else
                                if softwarePassNumber < installedSoftwarePassNumber && software.passEnabled
                                    equalScore += 1
                                else
                                    return false
                                end
                            end

                        end

                    else
                        if software.passEnabled
                            equalScore += 1
                        elsif installedSoftware.option(option.name) && !option.active
                            equalScore += 1
                        else
                            return false
                        end
                    end

                end

                return (equalScore == software.options.size)
            else
                return false
            end
        end

        def softwaresAreCodependent(software1 : ISM::SoftwareInformation, software2 : ISM::SoftwareInformation) : Bool
            return software1.allowCodependencies.includes?(software2.fullName) && software2.allowCodependencies.includes?(software1.fullName) && !software1.passEnabled && !software2.passEnabled
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
                if software.version > installedSoftware.version && installedSoftware.name != ""
                    return :update
                end

                return :new
            else

                #Option updates case (!check if it's the right condition)
                if software.options != installedSoftware.options
                    return :optionUpdate
                end

                return :rebuild
            end
        end

        def getAvailableSoftware(softwareName : String) : ISM::AvailableSoftware
            @softwares.each do |software|
                if softwareName == software.name
                    return software
                end
            end

            return ISM::AvailableSoftware.new
        end

        def getSoftwareInformation(userEntry : String) : ISM::SoftwareInformation
            result = ISM::SoftwareInformation.new


            path =  Ism.settings.rootPath +
                    ISM::Default::Path::InstalledSoftwaresDirectory +
                    userEntry.gsub(/[\@\-\:]+/,"/")

            if /@[A-Za-z0-9\-]+:[A-Za-z]+/.match(userEntry) != nil && File.exists?(path+ISM::Default::Filename::Information)

                if File.exists?(path+ISM::Default::Filename::SoftwareSettings)
                    result.loadInformationFile(path+ISM::Default::Filename::SoftwareSettings)
                else
                    result.loadInformationFile(path+ISM::Default::Filename::Information)
                end

            else

                @softwares.each do |entry|

                    if entry.name.downcase == userEntry.downcase || entry.fullName.downcase == userEntry.downcase
                        result.name = entry.name
                        if !entry.versions.empty?
                            temporary = entry.greatestVersion.clone
                            settingsFilePath = temporary.settingsFilePath

                            if File.exists?(settingsFilePath)
                                result.loadInformationFile(settingsFilePath)
                            else
                                result = temporary
                            end
                            break
                        end
                    else
                        entry.versions.each do |software|
                            if software.versionName.downcase == userEntry.downcase || software.fullVersionName.downcase == userEntry.downcase
                                temporary = software.clone
                                settingsFilePath = temporary.settingsFilePath

                                if File.exists?(settingsFilePath)
                                    result.loadInformationFile(settingsFilePath)
                                else
                                    result = temporary
                                end
                                break
                            end
                        end
                    end

                end

            end

            return result
        end

        def checkEnteredArguments
            matchingOption = false

            terminalTitleArguments = (ARGV.empty? ? "" : ARGV.join(" "))
            setTerminalTitle("#{ISM::Default::CommandLine::Name} #{terminalTitleArguments}")

            if ARGV.empty?
                matchingOption = true
                @options[0+@debugLevel].start
                resetTerminalTitle
            else
                @options.each_with_index do |argument, index|
                    if ARGV[0] == ISM::Default::Option::Debug::ShortText || ARGV[0] == ISM::Default::Option::Debug::LongText
                        @debugLevel = 1
                    end

                    if @debugLevel == 0 || @debugLevel == 1 && ARGV.size < 2 || @debugLevel == 1 && ARGV.size == 1
                        if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                            matchingOption = true
                            @options[index].start
                            resetTerminalTitle
                            break
                        end
                    end

                    if @debugLevel == 1 && ARGV.size > 1
                        if ARGV[0+@debugLevel] == argument.shortText || ARGV[0+@debugLevel] == argument.longText
                            matchingOption = true
                            @options[index].start
                            resetTerminalTitle
                            break
                        end
                    end
                end
            end

            if !matchingOption
                showErrorUnknowArgument
            end
        end

        def printNeedSuperUserAccessNotification
            puts "#{ISM::Default::CommandLine::NeedSuperUserAccessText.colorize(:yellow)}"
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
            puts "\t| #{message}"
        end

        def printErrorNotification(message : String, error)
            puts "[#{"!".colorize(:red)}] #{message}"
            if typeof(error) == Exception
                puts "[#{"!".colorize(:red)}] "
                pp error
            end
        end

        def printInformationNotificationTitle(name : String, version : String)
            limit = name.size+version.size+2
            text = "#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/"

            separatorText = String.new

            (0..limit).each do |index|
                separatorText += "-"
            end

            separatorText = "#{separatorText.colorize(:green)}"

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
            printProcessNotification(ISM::Default::CommandLine::DownloadText+softwareInformation.name)
        end

        def notifyOfCheck(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::CheckText+softwareInformation.name)
        end

        def notifyOfExtract(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::ExtractText+softwareInformation.name)
        end

        def notifyOfPatch(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::PatchText+softwareInformation.name)
        end

        def notifyOfLocalPatch(patchName : String)
            printSubProcessNotification(ISM::Default::CommandLine::LocalPatchText+"#{patchName.colorize(:yellow)}")
        end

        def notifyOfPrepare(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::PrepareText+softwareInformation.name)
        end

        def notifyOfConfigure(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::ConfigureText+softwareInformation.name)
        end

        def notifyOfBuild(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::BuildText+softwareInformation.name)
        end

        def notifyOfPrepareInstallation(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::PrepareInstallationText+softwareInformation.name)
        end

        def notifyOfInstall(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::InstallText+softwareInformation.name)
        end

        def notifyOfUpdateKernelOptionsDatabase(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::UpdateKernelOptionsDatabaseText+softwareInformation.name)
        end

        def notifyOfRecordNeededKernelFeatures(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::RecordNeededKernelFeaturesText+softwareInformation.name)
        end

        def notifyOfClean(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::CleanText+softwareInformation.name)
        end

        def notifyOfRecordUnneededKernelFeatures(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::RecordUnneededKernelFeaturesText+softwareInformation.name)
        end

        def notifyOfUninstall(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::UninstallText+softwareInformation.name)
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

        def notifyOfCheckError(archive : String, md5sum : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorCheckText1 +
                                    archive +
                                    ISM::Default::CommandLine::ErrorCheckText2 +
                                    md5sum, error)
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

        def notifyOfUpdateUserFileError(data : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorUpdateUserFileText+data, error)
        end

        def notifyOfUpdateGroupFileError(data : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorUpdateGroupFileText+data, error)
        end

        def notifyOfMakeLinkError(path : String, targetPath : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorMakeLinkText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMakeLinkText2 +
                                    targetPath, error)
        end

        def notifyOfMakeLinkFileExistError(path : String, targetPath : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorMakeLinkFileExistText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMakeLinkFileExistText2 +
                                    targetPath +
                                    ISM::Default::CommandLine::ErrorMakeLinkFileExistText3, error)
        end

        def notifyOfMakeLinkUnknowTypeError(path : String, targetPath : String, linkType : Symbol, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText2 +
                                    targetPath +
                                    ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText3 +
                                    linkType.to_s, error)
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

        def notifyOfCopyAllFilesFinishingError(path : String, destination : String,text : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorCopyAllFilesFinishingText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorCopyAllFilesFinishingText2 +
                                    path +
                                    ISM::Default::CommandLine::ErrorCopyAllFilesFinishingText3 +
                                    destination, error)
        end

        def notifyOfCopyAllFilesRecursivelyFinishingError(path : String, destination : String,text : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorCopyAllFilesRecursivelyFinishingText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorCopyAllFilesRecursivelyFinishingText2 +
                                    path +
                                    ISM::Default::CommandLine::ErrorCopyAllFilesRecursivelyFinishingText3 +
                                    destination, error)
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

        def notifyOfReplaceTextAllFilesNamedError(path : String, filename : String, text : String, newText : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorReplaceTextAllFilesNamedText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorReplaceTextAllFilesNamedText2 +
                                    newText +
                                    ISM::Default::CommandLine::ErrorReplaceTextAllFilesNamedText3 +
                                    filename +
                                    ISM::Default::CommandLine::ErrorReplaceTextAllFilesNamedText4 +
                                    path, error)
        end

        def notifyOfReplaceTextAllFilesRecursivelyNamedError(path : String, filename : String, text : String, newText : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorReplaceTextAllFilesRecursivelyNamedText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorReplaceTextAllFilesRecursivelyNamedText2 +
                                    newText +
                                    ISM::Default::CommandLine::ErrorReplaceTextAllFilesRecursivelyNamedText3 +
                                    filename +
                                    ISM::Default::CommandLine::ErrorReplaceTextAllFilesRecursivelyNamedText4 +
                                    path, error)
        end

        def notifyOfDeleteAllFilesFinishingError(path : String, text : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorDeleteAllFilesFinishingText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorDeleteAllFilesFinishingText2 +
                                    path, error)
        end

        def notifyOfDeleteAllFilesRecursivelyFinishingError(path : String, text : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorDeleteAllFilesRecursivelyFinishingText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorDeleteAllFilesRecursivelyFinishingText2 +
                                    path, error)
        end

        def notifyOfDeleteAllHiddenFilesError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorDeleteAllHiddenFilesText+path, error)
        end

        def notifyOfDeleteAllHiddenFilesRecursivelyError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorDeleteAllHiddenFilesRecursivelyText+path, error)
        end

        def notifyOfRunSystemCommandError(arguments : Array(String), path = String.new, environment = Hash(String, String).new, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorRunSystemCommandText1 +
                                    arguments.join(" ") +
                                    ISM::Default::CommandLine::ErrorRunSystemCommandText2 +
                                    path +
                                    ISM::Default::CommandLine::ErrorRunSystemCommandText3 +
                                    (environment.map { |key| key.join("=") }).join(" "),
                                    error)
        end

        def notifyOfGenerateEmptyFileError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorGenerateEmptyFileText+path, error)
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

        def notifyOfDeleteDirectoryRecursivelyError(directory : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorDeleteDirectoryRecursivelyText+directory, error)
        end

        def notifyOfSetPermissionsError(path : String, permissions : Int, error = nil)
            if path.is_a?(Enumerable(String))
                path = path.join(",")
            end
            printErrorNotification( ISM::Default::CommandLine::ErrorSetPermissionsText1 +
                                    permissions.to_s +
                                    ISM::Default::CommandLine::ErrorSetPermissionsText2 +
                                    path, error)
        end

        def notifyOfSetPermissionsRecursivelyError(path : String, permissions : Int, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorSetPermissionsRecursivelyText1 +
                                    permissions.to_s +
                                    ISM::Default::CommandLine::ErrorSetPermissionsRecursivelyText2 +
                                    path, error)
        end

        def notifyOfSetOwnerError(path : String, uid : Int | String, gid : Int | String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorSetOwnerText1 +
                                    uid.to_s +
                                    ISM::Default::CommandLine::ErrorSetOwnerText2 +
                                    gid.to_s +
                                    ISM::Default::CommandLine::ErrorSetOwnerText3 +
                                    path, error)
        end

        def notifyOfSetOwnerRecursivelyError(path : String, uid : Int | String, gid : Int | String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorSetOwnerRecursivelyText1 +
                                    uid.to_s +
                                    ISM::Default::CommandLine::ErrorSetOwnerRecursivelyText2 +
                                    gid.to_s +
                                    ISM::Default::CommandLine::ErrorSetOwnerRecursivelyText3 +
                                    path, error)
        end

        def notifyOfFileReplaceTextError(filePath : String, text : String, newText : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorFileReplaceTextText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorFileReplaceTextText2 +
                                    newText +
                                    ISM::Default::CommandLine::ErrorFileReplaceTextText3 +
                                    filePath, error)
        end

        def notifyOfFileReplaceLineContainingError(filePath : String, text : String, newLine : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorFileReplaceLineContainingText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorFileReplaceLineContainingText2 +
                                    newLine +
                                    ISM::Default::CommandLine::ErrorFileReplaceLineContainingText3 +
                                    filePath, error)
        end

        def notifyOfReplaceTextAtLineNumberError(filePath : String, text : String, newText : String, lineNumber : UInt64, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorReplaceTextAtLineNumberText1 +
                                    text +
                                    ISM::Default::CommandLine::ErrorReplaceTextAtLineNumberText2 +
                                    newText +
                                    ISM::Default::CommandLine::ErrorReplaceTextAtLineNumberText3 +
                                    filePath +
                                    ISM::Default::CommandLine::ErrorReplaceTextAtLineNumberText4 +
                                    lineNumber.to_s, error)
        end

        def notifyOfFileDeleteLineError(filePath : String, lineNumber : UInt64, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorFileDeleteLineText1 +
                                    lineNumber.to_s +
                                    ISM::Default::CommandLine::ErrorFileDeleteLineText2 +
                                    filePath, error)
        end

        def notifyOfGetFileContentError(filePath : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorGetFileContentText+filePath, error)
        end

        def notifyOfFileWriteDataError(filePath : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorFileWriteDataText+filePath, error)
        end

        def notifyOfFileAppendDataError(filePath : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorFileAppendDataText+filePath, error)
        end

        def notifyOfFileUpdateContentError(filePath : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorFileUpdateContentText+filePath, error)
        end

        def notifyOfUpdateKernelOptionsDatabaseError(software : ISM::SoftwareInformation, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorUpdateKernelOptionsDatabaseText+software.versionName, error)
        end

        def resetCalculationAnimation
            @calculationStartingTime = Time.monotonic
            @frameIndex = 0
            @reverseAnimation = false
        end

        def playCalculationAnimation(@text = ISM::Default::CommandLine::CalculationWaitingText)
            currentTime = Time.monotonic

            if (currentTime - @calculationStartingTime).milliseconds > 40
                if @frameIndex == @text.size && !@reverseAnimation
                    @reverseAnimation = true
                end

                if @frameIndex < 1
                    @reverseAnimation = false
                end

                if @reverseAnimation
                    print "\033[1D"
                    print " "
                    print "\033[1D"
                    @frameIndex -= 1
                end

                if !@reverseAnimation
                    print "#{@text[@frameIndex].colorize(:green)}"
                    @frameIndex += 1
                end

                @calculationStartingTime = Time.monotonic
            end
        end

        def cleanCalculationAnimation
            loop do
                if @frameIndex > 0
                    print "\033[1D"
                    print " "
                    print "\033[1D"
                    @frameIndex -= 1
                else
                    break
                end
            end
        end

        def getRequestedSoftwares(list : Array(String)) : Array(ISM::SoftwareInformation)
            softwaresList = Array(ISM::SoftwareInformation).new

            list.each do |entry|
                software = getSoftwareInformation(entry)
                if software.name != ""
                    softwaresList << software
                end
            end

            return softwaresList
        end

        def setTerminalTitle(title : String)
            if @initialTerminalTitle == ""
                @initialTerminalTitle= "\e"
            end
            STDOUT << "\e]0; #{title}\e\\"
        end

        def resetTerminalTitle
            setTerminalTitle(@initialTerminalTitle)
        end

        def exitProgram
            resetTerminalTitle
            exit 1
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
            if allowTitle
                puts "#{ISM::Default::CommandLine::UnavailableText1.colorize(:yellow)}"
                puts "\n"
            end

            dependencyText = "#{dependency.name.colorize(:magenta)}" + " /" + "#{dependency.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

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

            softwareText = "#{software.name.colorize(:green)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/"

            puts "\t" + dependencyText + " " + optionsText + missingDependencyText + softwareText + "\n"

            if allowTitle
                puts "\n"
            end
        end

        def showInextricableDependenciesMessage(dependencies : Array(ISM::SoftwareInformation))
            puts "#{ISM::Default::CommandLine::InextricableText.colorize(:yellow)}"
            puts "\n"

            dependencies.each do |software|
                softwareText = "#{software.name.colorize(:magenta)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                optionsText = "{ "

                software.options.each do |option|
                    if option.active
                        optionsText += "#{option.name.colorize(:red)}"
                    else
                        optionsText += "#{option.name.colorize(:blue)}"
                    end
                    optionsText += " "
                end
                optionsText += "}"

                puts "\t" + softwareText + " " + optionsText + "\n"
            end

            puts "\n"
        end

        def showMissingSelectedDependenciesMessage(name : String, version : String, dependencySelection : Array(Array(String)))
            puts "#{ISM::Default::CommandLine::MissingSelectedDependenciesText.colorize(:yellow)}"
            puts "\n"

            puts "#{name.colorize(:magenta)}" + " /" + "#{version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

            dependencySelection.each do |selection|
                puts "\t#{ISM::Default::CommandLine::MissingSelectionText.colorize(:magenta)} #{selection.join(" | ").colorize(:magenta)}"
            end

            puts "\n"
        end

        def showCalculationDoneMessage
            cleanCalculationAnimation
            print "#{ISM::Default::CommandLine::CalculationDoneText.colorize(:green)}\n"
        end

        def showCalculationTitleMessage
            print "#{ISM::Default::CommandLine::CalculationTitle}"
        end

        def showSoftwares(neededSoftwares : Array(ISM::SoftwareInformation), mode = :installation)
            puts "\n"

            neededSoftwares.each do |software|
                softwareText = "#{"@#{software.port}".colorize(:red)}:#{software.name.colorize(:green)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/ "
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
                    additionalText += "("

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

                    additionalText += ")"
                end

                puts "\t" + softwareText + " " + optionsText + " " + additionalText + "\n"
            end

            puts "\n"
        end

        def showInstallationQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + ISM::Default::CommandLine::InstallSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{ISM::Default::CommandLine::InstallQuestion.colorize.mode(:underline)}" +
                    "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                    "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
        end

        def showUninstallationQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + ISM::Default::CommandLine::UninstallSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{ISM::Default::CommandLine::UninstallQuestion.colorize.mode(:underline)}" +
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
            userInput = ""
            userAgreement = false

            loop do
                userInput = gets

                if userInput == ISM::Default::CommandLine::YesReplyOption
                    return true
                elsif userInput == ISM::Default::CommandLine::NoReplyOption
                    return false
                else
                    return false
                end
            end
        end

        def updateInstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String)
            setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::InstallingText} @#{port}:#{name} /#{version}/")
        end

        def updateUninstallationTerminalTitle(index : Int32, limit : Int32, port : String, name : String, version : String)
            setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::UninstallingText} @#{port}:#{name} /#{version}/")
        end

        def cleanBuildingDirectory(path : String)
            if Dir.exists?(path)
                FileUtils.rm_r(path)
            end

            Dir.mkdir_p(path)
        end

        def showSeparator
            puts "\n"
            puts "#{ISM::Default::CommandLine::Separator.colorize(:green)}\n"
            puts "\n"
        end

        def showEndSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
            puts
            puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
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
        end

        def getRequestedSoftwareVersionNames
            result = "requestedSoftwareVersionNames = ["

            @requestedSoftwares.each_with_index do |software, index|

                if @requestedSoftwares.size == 1
                    result = "requestedSoftwareVersionNames = [\"#{software.versionName}\"]"
                else
                    if index == 0
                        result += "\t\"#{software.versionName}\",\n"
                    elsif index != @requestedSoftwares.size-1
                        result += "\t\t\t\t\t\t\t\t\t\"#{software.versionName}\",\n"
                    else
                        result += "\t\t\t\t\t\t\t\t\t\"#{software.versionName}\"]\n"
                    end
                end

            end

            return result
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
                    requiredTargetArrayResult = "targets = [Target#{index}.new(\"#{software.filePath}\")]"
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
        end

        def makeLogDirectory(path : String)
            if !Dir.exists?(path)
                Dir.mkdir_p(path)
            end
        end

        def startInstallationProcess(neededSoftwares : Array(ISM::SoftwareInformation))
            tasks = <<-CODE
                    puts

                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareVersionNames}

                    #LOADING TARGETS, ADDITIONAL INFORMATION INDEX AND NEEDED OPTIONS
                    #{getRequiredTargets(neededSoftwares)}

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase

                    limit = targets.size

                    targets.each_with_index do |target, index|

                        information = target.information
                        port = information.port
                        name = information.name
                        version = information.version
                        versionName = information.versionName

                        #START INSTALLATION PROCESS

                        Ism.updateInstallationTerminalTitle(index, limit, port, name, version)

                        Ism.showStartSoftwareInstallingMessage(index, limit, port, name, version)

                        Ism.cleanBuildingDirectory(Ism.settings.rootPath+target.information.builtSoftwareDirectoryPath)

                        begin
                            target.download
                            target.check
                            target.extract
                            target.patch
                            target.prepare
                            target.configure
                            target.build
                            target.prepareInstallation
                            target.install
                            target.recordNeededKernelFeatures
                            target.clean
                        rescue
                            if File.exists?(target.information.installedFilePath)
                                Ism.removeInstalledSoftware(target.information)
                            end

                            Ism.exitProgram
                        end

                        Ism.cleanBuildingDirectory(Ism.settings.rootPath+target.information.builtSoftwareDirectoryPath)

                        if Ism.softwareIsRequestedSoftware(target.information)
                            Ism.addSoftwareToFavouriteGroup(versionName)
                        end

                        Ism.showEndSoftwareInstallingMessage(index, limit, port, name, version)

                        if index < limit-1
                            Ism.showSeparator
                        end

                    end

                    puts

                    targetsAdditionalInformationIndex.each do |index|
                        targets[index].showInformations
                    end

                    CODE

            generateTasksFile(tasks)
            buildTasksFile
            runTasksFile(logEnabled: true, softwareList: neededSoftwares)
        end

        def buildTasksFile
            process = Process.run(  "crystal build #{ISM::Default::Filename::Task}.cr -o #{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if !process.success?
                exitProgram
            end
        end

        def runTasksFile(logEnabled = false, softwareList = Array(ISM::SoftwareInformation).new)

            logIOMemory = IO::Memory.new

            logWriter = logEnabled ? IO::MultiWriter.new(STDOUT,logIOMemory) : Process::Redirect::Inherit

            process = Process.run(  "./#{ISM::Default::Filename::Task}",
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
                exitProgram
            end
        end

        def startUninstallationProcess(unneededSoftwares : Array(ISM::SoftwareInformation))
            tasks = <<-CODE
                    puts "\n"

                    #LOADING LIBRARIES
                    #{getRequiredLibraries}

                    #LOADING REQUESTED SOFTWARE VERSION NAMES
                    #{getRequestedSoftwareVersionNames}

                    #LOADING TARGETS
                    #{getRequiredTargets(unneededSoftwares)}

                    #LOADING DATABASE
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase

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
                            target.recordUnneededKernelFeatures
                            target.uninstall
                        rescue
                            Ism.exitProgram
                        end

                        Ism.showEndSoftwareInstallingMessage(index, limit, port, name, version)

                        if index < limit-1
                            Ism.showSeparator
                        end

                    end

                    CODE

            generateTasksFile(tasks)
            buildTasksFile
            runTasksFile
        end

        def showStartSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
            puts    "\n#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{ISM::Default::CommandLine::InstallingText} " +
                    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
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
                    sleep 0
                end

            end

            cleanCalculationAnimation
        end

        def getRequiredDependencies(softwares : Array(ISM::SoftwareInformation), allowRebuild = false, allowDeepSearch = false, allowSkipUnavailable = false) : Hash(String, ISM::SoftwareInformation)

            dependencies = Hash(String, ISM::SoftwareInformation).new
            currentDependencies = softwares.map { |entry| entry.toSoftwareDependency}
            nextDependencies = Array(ISM::SoftwareDependency).new

            #TRACE DEPENDENCY TREE FOR EACH REQUESTED SOFTWARE
            dependencyTree = Hash(String, Array(String)).new
            invalidDependencies = Array(ISM::SoftwareInformation).new
            ##################################################

            loop do

                playCalculationAnimation

                if currentDependencies.empty?
                    break
                end

                currentDependencies.each do |dependency|
                    playCalculationAnimation

                    #EXPERIMENTAL
                    if !dependencyTree.has_key?(dependency.hiddenName)
                        dependencyTree[dependency.hiddenName] = (dependency.dependencies.map { |entry| entry.hiddenName})
                    else
                        dependencyTree[dependency.hiddenName] += (dependency.dependencies.map { |entry| entry.hiddenName})
                        dependencyTree[dependency.hiddenName] = dependencyTree[dependency.hiddenName].uniq
                    end
                    #############

                    dependencyInformation = dependency.information
                    installed = softwareIsInstalled(dependencyInformation)

                    if !installed || installed && allowRebuild == true && softwareIsRequestedSoftware(dependencyInformation) && !dependencyInformation.passEnabled || allowDeepSearch == true

                        if !dependencyInformation.isValid

                            invalidDependencies.push(ISM::SoftwareInformation.new(name: dependency.name, version: dependency.versionString))
                            #if allowSkipUnavailable == true

                                ###
                                #dependencyTree.keys.each do |key|

                                    #if dependencyTree[key].includes?(dependencyInformation.hiddenName)
                                    #    @unavailableDependencySignals.push([dependencies[key],dependencyInformation])
                                    #end

                                #end
                                ###

                                #return Array(ISM::SoftwareInformation).new
                                #return Hash(String, ISM::SoftwareInformation).new

                            #else

                                #showCalculationDoneMessage

                                ###
                                #dependencyTree.keys.each do |key|

                                    #if dependencyTree[key].includes?(dependencyInformation.hiddenName)
                                        #showUnavailableDependencyMessage(dependencies[key],dependencyInformation)
                                        #exitProgram
                                    #end

                                #end
                                ###

                                #showUnavailableDependencyMessage(softwares,dependencyInformation)
                                #exitProgram

                            #end
                        end

                        key = dependency.hiddenName

                        if dependencies.has_key?(key)

                            differentOptions = (dependencies[key].dependencies.size - dependency.dependencies.size).abs > 0

                            if differentOptions
                                dependency.options.each do |option|
                                    playCalculationAnimation

                                    dependencies[key].enableOption(option)
                                end

                                nextDependencies += dependencies[key].dependencies
                            end

                        else
                            dependencies[key] = dependencyInformation

                            nextDependencies += dependencies[key].dependencies
                        end

                    end

                end

                currentDependencies = nextDependencies.dup
                nextDependencies.clear

            end

            #NEED TO PUSH NOW THE SOFTWARE COUPLE
            if !invalidDependencies.empty?

                invalidDependencies.each do |dependency|

                    name = dependency.hiddenName

                    dependencyTree.keys.each do |key|

                        if dependencyTree[key].includes?(name)
                            @unavailableDependencySignals.push([dependencies[key],dependency])
                        end

                    end

                end

            #####################################

                if allowSkipUnavailable == true

                    return Hash(String, ISM::SoftwareInformation).new

                else

                    @unavailableDependencySignals.each do |softwares|
                        showUnavailableDependencyMessage(softwares[0],softwares[1])
                        exitProgram
                    end

                end

            end

            return dependencies
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
                                                end
                                            end
                                        end

                                    end
                                    #--------------------------------------------------------------------

                                end

                            #Inextricable dependency case
                            else
                                showCalculationDoneMessage
                                showInextricableDependenciesMessage([calculatedDependencies[key1][0],calculatedDependencies[key2][0]])
                                exitProgram
                            end

                        end

                    end
                end
            end

            return calculatedDependencies
        end

        def getSortedDependencies(dependencyTable : Hash(String, Array(ISM::SoftwareInformation))) : Array(ISM::SoftwareInformation)

            result = dependencyTable.to_a.sort_by { |k, v| v.size }

            return result.map { |entry| entry[1][0]}
        end

        def generateTasksFile(tasks : String)
            File.write("#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)
        end

        def getNeededSoftwares : Array(ISM::SoftwareInformation)
            softwareHash = getRequiredDependencies(@requestedSoftwares, allowRebuild: true)

            dependencyTable = getDependencyTable(softwareHash)

            return getSortedDependencies(dependencyTable)
        end

        def getUnneededSoftwares : Array(ISM::SoftwareInformation)
            wrongArguments = Array(String).new
            requiredSoftwares = Hash(String,ISM::SoftwareInformation).new
            unneededSoftwares = Array(ISM::SoftwareInformation).new

            #GET ALL REQUIRED SOFTWARES
            @favouriteGroups.each do |group|
                playCalculationAnimation

                #For each software in favourites: add entry in requiredSoftwares
                getRequestedSoftwares(group.softwares).each do |software|
                    playCalculationAnimation

                    #If software in favourite is not requested for removal, it is require, else no
                    if !softwareIsRequestedSoftware(software)

                        requiredSoftwares[software.versionName] = software

                        #For each dependency of favourites: add entry in requiredSoftwares
                        getRequiredDependencies([software], allowDeepSearch: true).values.each do |dependency|
                            playCalculationAnimation

                            requiredSoftwares[dependency.versionName] = dependency
                        end

                    end

                end

            end

            #CHECK IF ONE OF THE REQUESTED SOFTWARE IS NOT REQUIRED
            @requestedSoftwares.each do |software|
                playCalculationAnimation

                #If it's require, add to wrong arguments
                if requiredSoftwares.has_key?(software.versionName)
                    wrongArguments.push(software.versionName)
                end

            end

            #CHECK FOR ALL INSTALLED SOFTWARES IF THERE ARE ANY USELESS SOFTWARES
            @installedSoftwares.each do |software|
                playCalculationAnimation

                #If it's not require, add to unneeded softwares
                if !requiredSoftwares.has_key?(software.versionName)
                    unneededSoftwares.push(software)
                end

            end

            if !wrongArguments.empty?
                showCalculationDoneMessage
                showSoftwareNeededMessage(wrongArguments)
                exitProgram
            end

            return unneededSoftwares
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

                    if installedSoftware.name == availableSoftware.name
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
                @unavailableDependencySignals.uniq! { |entry| [entry[0].versionName,entry[1].versionName]}

                #Show all skipped updates
                @unavailableDependencySignals.each do |signal|
                    showUnavailableDependencyMessage(signal[0], signal[1], allowTitle: false)
                end

            end

            puts

            return softwareToUpdate
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
        end

        def deletePatch(patchName : String, softwareVersionName : String) : Bool
            path = @settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{softwareVersionName}/#{patchName}"

            begin
                FileUtils.rm(path)
            rescue
                return false
            end

            return true
        end

        #############################################
        #GERER LE CAS OU LE NOYAU N'EST PAS INSTALLE#
        #############################################
        #COMMENT GERER SI UNE FEATURE AVAIT DES DEPENDANCES LORS DE LA DESINSTALLATION ?

        def getKernelFeatureDependencies(feature : String) : Array(String)

        end

        def enableKernelFeature(feature : String)

        end

        def disableKernelFeature(feature : String)

        end

        def enableKernelFeatures(features : Array(String))
            features.each do |feature|
                enableKernelFeature(feature)
            end
        end

        def disableKernelFeatures(features : Array(String))
            features.each do |feature|
                disableKernelFeature(feature)
            end
        end

    end

end
