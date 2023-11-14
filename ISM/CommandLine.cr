module ISM

    class CommandLine

        property requestedSoftwares : Array(ISM::SoftwareInformation)
        property softwaresNeedRebuild : Array(ISM::SoftwareInformation)
        property neededKernelFeatures : Array(String)
        property unneededKernelFeatures : Array(String)
        property debugLevel : Int32
        property options : Array(ISM::CommandLineOption)
        property settings : ISM::CommandLineSettings
        property systemSettings : ISM::CommandLineSystemSettings
        property kernelOptions : Array(ISM::KernelOption)
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
            @systemSettings = ISM::CommandLineSystemSettings.new
            @kernelOptions = Array(ISM::KernelOption).new
            @softwares = Array(ISM::AvailableSoftware).new
            @installedSoftwares = Array(ISM::SoftwareInformation).new
            @ports = Array(ISM::Port).new
            @portsSettings = ISM::CommandLinePortsSettings.new
            @mirrors = Array(ISM::Mirror).new
            @mirrorsSettings = ISM::CommandLineMirrorsSettings.new
            @favouriteGroups = Array(ISM::FavouriteGroup).new
            @initialTerminalTitle = String.new
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
            if !Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory)
                Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory)
            end

            kernelOptionFiles = Dir.children(Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory)

            kernelOptionFiles.each do |kernelOptionFile|
                kernelOption = ISM::KernelOption.new
                kernelOption.loadInformationFile(kernelOptionFile)
                @kernelOptions << kernelOption
            end
        end

        def loadSoftwareDatabase
            if !Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory)
                Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory)
            end

            portDirectories = Dir.children(Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children(Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+portDirectory).reject!(&.starts_with?(".git"))

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children(  Ism.settings.rootPath +
                                                        ISM::Default::Path::SoftwaresDirectory+portDirectory + "/" +
                                                        softwareDirectory)
                    softwaresInformations = Array(ISM::SoftwareInformation).new

                    versionDirectories.each do |versionDirectory|

                        softwareInformation = ISM::SoftwareInformation.new

                        if File.exists?(Ism.settings.rootPath +
                                        ISM::Default::Path::SettingsSoftwaresDirectory +
                                        portDirectory+ "/" +
                                        softwareDirectory + "/" +
                                        versionDirectory + "/" +
                                        ISM::Default::Filename::SoftwareSettings)
                            softwareInformation.loadInformationFile(Ism.settings.rootPath +
                                                                    ISM::Default::Path::SettingsSoftwaresDirectory +
                                                                    portDirectory+ "/" +
                                                                    softwareDirectory + "/" +
                                                                    versionDirectory + "/" +
                                                                    ISM::Default::Filename::SoftwareSettings)

                        else
                            softwareInformation.loadInformationFile(Ism.settings.rootPath +
                                                                    ISM::Default::Path::SoftwaresDirectory +
                                                                    portDirectory+ "/" +
                                                                    softwareDirectory + "/" +
                                                                    versionDirectory + "/" +
                                                                    ISM::Default::Filename::Information)
                        end

                        softwaresInformations << softwareInformation

                    end

                    @softwares << ISM::AvailableSoftware.new(softwareDirectory,softwaresInformations)

                end

            end

        end

        def loadPortsDatabase
            if !Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::PortsDirectory)
                Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::PortsDirectory)
            end

            portsFiles = Dir.children(Ism.settings.rootPath+ISM::Default::Path::PortsDirectory)

            portsFiles.each do |portFile|
                port = ISM::Port.new(portFile[0..-6])
                port.loadPortFile
                @ports << port
            end
        end

        def loadMirrorsDatabase
            if !Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::MirrorsDirectory)
                Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::MirrorsDirectory)
            end

            mirrorsFiles = Dir.children(Ism.settings.rootPath+ISM::Default::Path::MirrorsDirectory)

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
            if !Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)
                Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)
            end

            favouriteGroupsFiles = Dir.children(Ism.settings.rootPath+ISM::Default::Path::FavouriteGroupsDirectory)

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
            @systemSettings.loadSystemSettingsFile
            @portsSettings.loadPortsSettingsFile
            @mirrorsSettings.loadMirrorsSettingsFile
        end

        def loadInstalledSoftwareDatabase
            if !Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory)
                Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory)
            end

            portDirectories = Dir.children(Ism.settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory)

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children(Ism.settings.rootPath+ISM::Default::Path::InstalledSoftwaresDirectory+portDirectory)

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children(  Ism.settings.rootPath +
                                                        ISM::Default::Path::InstalledSoftwaresDirectory+portDirectory + "/" +
                                                        softwareDirectory)

                    versionDirectories.each do |versionDirectory|

                        softwareInformation = ISM::SoftwareInformation.new

                        softwareInformation.loadInformationFile(Ism.settings.rootPath +
                                                                ISM::Default::Path::InstalledSoftwaresDirectory +
                                                                portDirectory+ "/" +
                                                                softwareDirectory + "/" +
                                                                versionDirectory + "/" +
                                                                ISM::Default::Filename::Information)

                        @installedSoftwares << softwareInformation

                    end

                end

            end
        end

        def userInputMatchWithFilter(input : String, filter : Regex | Array(Regex))
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
            #Need to manage uninstallation of a pass
            @installedSoftwares.each do |installedSoftware|
                if software.toSoftwareDependency.hiddenName == installedSoftware.toSoftwareDependency.hiddenName
                    installedSoftware.installedFiles.each do |file|
                        FileUtils.rm_r(Ism.settings.rootPath+file)
                    end
                    break
                end
            end

            FileUtils.rm_r(software.installedDirectoryPath)
        end

        def softwareAnyVersionInstalled(softwareName : String) : Bool
            @installedSoftwares.each do |installedSoftware|
                if softwareName == installedSoftware.name && !installedSoftware.passEnabled
                    return true
                end
            end

            return false
        end

        def softwareIsInstalled(software : ISM::SoftwareInformation) : Bool
            @installedSoftwares.each do |installedSoftware|
                if software.name == installedSoftware.name && software.version == installedSoftware.version
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
                end
            end

            return false
        end

        def getAvailableSoftware(softwareName : String) : ISM::AvailableSoftware
            @softwares.each do |software|
                if softwareName == software.name
                    return software
                end
            end

            return ISM::AvailableSoftware.new
        end

        def getSoftwareInformation(versionName : String) : ISM::SoftwareInformation
            result = ISM::SoftwareInformation.new

            @softwares.each do |entry|

                if entry.name.downcase == versionName.downcase
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
                        if software.versionName.downcase == versionName.downcase
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

        def notifyOfCheckError(archive : String, md5sum : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorCheckText1 +
                                    archive +
                                    ISM::Default::CommandLine::ErrorCheckText2 +
                                    md5sum, error)
        end

        def notifyOfExtractError(archiveName : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorExtractText+archiveName, error)
        end

        def notifyOfApplyPatchError(patchName : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorApplyPatchText+patchName, error)
        end

        def notifyOfMakeSymbolicLinkError(path : String, targetPath : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorMakeSymbolicLinkText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMakeSymbolicLinkText2 +
                                    targetPath, error)
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

        def showUnavailableDependencyMessage(software : ISM::SoftwareInformation, dependency : ISM::SoftwareDependency)
            puts "#{ISM::Default::CommandLine::UnavailableText1.colorize(:yellow)}"
            puts "\n"

            dependencyText = "#{dependency.name.colorize(:magenta)}" + " /" + "#{dependency.requiredVersion.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

            optionsText = "{ "

            if dependency.information.options.empty?
                optionsText += "#{"#{ISM::Default::CommandLine::NoOptionText} ".colorize(:dark_gray)}"
            end

            dependency.information.options.each do |option|
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

            puts "\n"
        end

        def showInextricableDependenciesMessage(dependencies : Array(ISM::SoftwareDependency))
            puts "#{ISM::Default::CommandLine::InextricableText.colorize(:yellow)}"
            puts "\n"

            dependencies.each do |software|
                softwareText = "#{software.name.colorize(:magenta)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                optionsText = "{ "

                software.information.options.each do |option|
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

        def showDependenciesAtUpperLevelMessage(dependencies : Array(ISM::SoftwareDependency))
            puts "#{ISM::Default::CommandLine::DependenciesAtUpperLevelText.colorize(:yellow)}"
            puts "\n"

            dependencies.each do |software|
                softwareText = "#{software.name.colorize(:magenta)}" + " /" + "#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                optionsText = "{ "

                software.information.options.each do |option|
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

        def showCalculationDoneMessage
            cleanCalculationAnimation
            print "#{ISM::Default::CommandLine::CalculationDoneText.colorize(:green)}\n"
        end

        def showCalculationTitleMessage
            print "#{ISM::Default::CommandLine::CalculationTitle}"
        end

        def showSoftwares(neededSoftwares : Array(ISM::SoftwareDependency), mode = :installation)
            puts "\n"

            neededSoftwares.each do |software|
                information = software.information

                softwareText = "#{information.name.colorize(:green)}" + " /" + "#{information.version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "
                optionsText = "{ "

                if information.options.empty?
                    optionsText += "#{"#{ISM::Default::CommandLine::NoOptionText} ".colorize(:dark_gray)}"
                end

                information.options.each do |option|
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
                    additionalText += "#{softwareIsInstalled(software.information) ? "#{ISM::Default::CommandLine::RebuildText}".colorize(:yellow) : "#{ISM::Default::CommandLine::NewText}".colorize(:yellow)}"
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

        def showUpdateQuestion(softwareNumber : Int32)
            summaryText = softwareNumber.to_s + ISM::Default::CommandLine::UpdateSummaryText + "\n"

            puts "#{summaryText.colorize(:green)}"

            print   "#{ISM::Default::CommandLine::UpdateQuestion.colorize.mode(:underline)}" +
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
                end
                if userInput == ISM::Default::CommandLine::NoReplyOption
                    return false
                end
            end
        end

        def updateInstallationTerminalTitle(index : Int32, limit : Int32, name : String, version : String)
            setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::InstallingText} #{name} /#{version}/")
        end

        def updateUninstallationTerminalTitle(index : Int32, limit : Int32, name : String, version : String)
            setTerminalTitle("#{ISM::Default::CommandLine::Name} [#{(index+1)} / #{limit}]: #{ISM::Default::CommandLine::UninstallingText} #{name} /#{version}/")
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

        def showEndSoftwareInstallingMessage(index : Int32, limit : Int32, name : String, version : String)
            puts
            puts    "#{name.colorize(:green)}" +
                    " #{ISM::Default::CommandLine::InstalledText} " +
                    "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                    "#{">>".colorize(:light_magenta)}" +
                    "\n"
        end

        def showEndSoftwareUninstallingMessage(index : Int32, limit : Int32, name : String, version : String)
            puts
            puts    "#{name.colorize(:green)}" +
                    " #{ISM::Default::CommandLine::UninstalledText} " +
                    "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                    "#{">>".colorize(:light_magenta)}" +
                    "\n"
        end

        def getEnabledOptions(software : ISM::SoftwareDependency) : String
            requiredOptions = String.new

            software.information.options.each do |option|
                if option.active
                    requiredOptions += "target.information.enableOption(\"#{option.name}\")\n"
                else
                    requiredOptions += "target.information.disableOption(\"#{option.name}\")\n"
                end
            end

            return requiredOptions
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

        def makeLogDirectory(path : String)
            if !Dir.exists?(path)
                Dir.mkdir_p(path)
            end
        end

        def startInstallationProcess(neededSoftwares : Array(ISM::SoftwareDependency))
            puts "\n"

            neededSoftwares.each_with_index do |software, index|
                limit = neededSoftwares.size
                name = software.name
                version = software.version

                updateInstallationTerminalTitle(index, limit, name, version)

                showStartSoftwareInstallingMessage(index, limit, name, version)

                runInstallationProcess(software)

                if @requestedSoftwares.any? { |entry| entry.versionName == software.versionName}
                    addSoftwareToFavouriteGroup(software.versionName)
                end

                showEndSoftwareInstallingMessage(index, limit, name, version)

                if index < neededSoftwares.size-1
                    showSeparator
                end
            end

            neededSoftwares.each do |software|
                runShowInformationProcess(software)
            end

            #Enable or disable needed kernel features
        end

        def startUninstallationProcess(unneededSoftwares : Array(ISM::SoftwareDependency))
            puts "\n"

            unneededSoftwares.each_with_index do |software, index|
                limit = unneededSoftwares.size
                name = software.name
                version = software.version

                updateUninstallationTerminalTitle(index, limit, name, version)

                showStartSoftwareUninstallingMessage(index, limit, name, version)

                runUninstallationProcess(software)

                showEndSoftwareUninstallingMessage(index, limit, name, version)

                if index < unneededSoftwares.size-1
                    showSeparator
                end
            end
        end

        def showStartSoftwareInstallingMessage(index : Int32, limit : Int32, name : String, version : String)
            puts    "\n#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{ISM::Default::CommandLine::InstallingText} " +
                    "#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                    "\n\n"
        end

        def showStartSoftwareUninstallingMessage(index : Int32, limit : Int32, name : String, version : String)
            puts    "\n#{"<<".colorize(:light_magenta)}" +
                    " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                    " / #{limit.to_s.colorize(:light_red)}" +
                    "] #{ISM::Default::CommandLine::UninstallingText} " +
                    "#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
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

        def getRequiredDependencies(software : ISM::SoftwareInformation, allowRebuild = false) : Array(ISM::SoftwareDependency)
            dependencies = Hash(String,ISM::SoftwareDependency).new
            currentDependencies = [software.toSoftwareDependency]
            nextDependencies = Array(ISM::SoftwareDependency).new

            loop do

                playCalculationAnimation

                if currentDependencies.empty?
                    break
                end

                currentDependencies.each do |dependency|

                    if !Ism.softwareIsInstalled(dependency.information) || Ism.softwareIsInstalled(dependency.information) && allowRebuild == true && dependency.information == software
                        playCalculationAnimation

                        dependencyInformation = dependency.information

                        #Software not available
                        if dependencyInformation.name == ""
                            showCalculationDoneMessage
                            showUnavailableDependencyMessage(software,dependency)
                            exitProgram
                        end

                        #Version not available
                        if dependencyInformation.version == ""
                            showCalculationDoneMessage
                            showUnavailableDependencyMessage(software,dependency)
                            exitProgram
                        end

                        #Need multiple version or need to fusion options
                        if dependencies.has_key?(dependency.hiddenName)

                            #Multiple versions of single software requested
                            if dependencies[dependency.hiddenName].version != dependency.version
                                dependencies[dependency.versionName] = dependency
                                nextDependencies += dependency.dependencies
                            end

                            #Different options requested
                            if dependencies[dependency.hiddenName].options != dependency.options
                                entry = dependency.dup
                                entry.options = (dependencies[dependency.hiddenName].options+dependency.options).uniq

                                dependencies[dependency.versionName] = entry
                                nextDependencies += entry.dependencies
                            end
                        else
                            dependencies[dependency.hiddenName] = dependency
                            nextDependencies += dependency.dependencies
                        end

                    end

                end

                currentDependencies = nextDependencies.dup
                nextDependencies.clear

            end

            return dependencies.values
        end

        def getDependenciesTable(softwareList : Array(ISM::SoftwareInformation)) : Hash(String,Array(ISM::SoftwareDependency))
            dependenciesTable = Hash(String,Array(ISM::SoftwareDependency)).new

            softwareList.each do |software|
                playCalculationAnimation

                key = software.toSoftwareDependency.hiddenName

                dependenciesTable[key] = getRequiredDependencies(software, true)

                dependenciesTable[key].each do |dependency|
                    playCalculationAnimation

                    dependencyInformation = dependency.information

                    if !softwareIsInstalled(dependencyInformation)
                        dependenciesTable[dependency.hiddenName] = getRequiredDependencies(dependencyInformation)
                    end

                end

            end

            keys = dependenciesTable.keys
            #Inextricable dependencies problem
            keys.each do |key1|
                playCalculationAnimation

                keys.each do |key2|
                    playCalculationAnimation

                    if key1 != key2
                        if dependenciesTable[key1].any?{|dependency| dependency.hiddenName == key2} && dependenciesTable[key2].any?{|dependency| dependency.hiddenName == key1}
                            showCalculationDoneMessage
                            showInextricableDependenciesMessage([dependenciesTable[key1][0],dependenciesTable[key2][0]])
                            exitProgram
                        end
                    end
                end
            end

            return dependenciesTable
        end

        def getSortedDependencies(dependenciesTable : Hash(String,Array(ISM::SoftwareDependency))) : Array(ISM::SoftwareDependency)
            result = Array(ISM::SoftwareDependency).new

            table = Hash(ISM::SoftwareDependency,Int32).new

            dependenciesTable.values.each do |dependencies|
                playCalculationAnimation

                table[dependencies[0]] = dependencies.size

                dependencies.each do |dependency|
                    playCalculationAnimation

                    if dependenciesTable.has_key?(dependency.hiddenName) && dependency.dependencies.size < dependenciesTable[dependency.hiddenName][0].dependencies.size
                        table[dependencies[0]] += (dependenciesTable[dependency.hiddenName][0].dependencies.size - dependency.dependencies.size).abs
                    end

                    if dependenciesTable.has_key?(dependency.versionName) && dependency.dependencies.size < dependenciesTable[dependency.versionName][0].dependencies.size
                        table[dependencies[0]] += (dependenciesTable[dependency.versionName][0].dependencies.size - dependency.dependencies.size).abs
                    end
                end
            end

            table.to_a.sort_by { |k, v| v }.each do |item|
                playCalculationAnimation

                result << item[0]
            end

            resultedSoftwareNames = result.map { |dependency| dependency.name }
            requestedSoftwareNames = @requestedSoftwares.map { |software| software.name }

            if !requestedSoftwareNames.includes?(requestedSoftwareNames[-1])
                dependenciesAtUpperLevelList = Array(ISM::SoftwareDependency).new

                result.reverse.each do |dependency|
                    if requestedSoftwareNames.includes?(dependency.name)
                        break
                    else
                        dependenciesAtUpperLevelList.push(dependency)
                    end
                end

                showCalculationDoneMessage
                showDependenciesAtUpperLevelMessage(dependenciesAtUpperLevelList)
                exitProgram
            end

            return result
        end

        def runShowInformationProcess(software : ISM::SoftwareDependency)
            tasks = generateShowInformationTasks(software)
            generateTasksFile(tasks)

            process = Process.run(  "crystal build #{ISM::Default::Filename::Task}.cr -o #{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if !process.success?
                exitProgram
            end

            process = Process.run(  "./#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if !process.success?
                exitProgram
            end
        end

        def runInstallationProcess(software : ISM::SoftwareDependency)
            cleanBuildingDirectory(@settings.rootPath+software.builtSoftwareDirectoryPath)

            tasks = generateInstallTasks(software)
            generateTasksFile(tasks)

            makeLogDirectory("#{@settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}")
            logFile = File.open("#{@settings.rootPath}#{ISM::Default::Path::LogsDirectory}#{software.port}/#{software.versionName}.log","w")
            logWriter = IO::MultiWriter.new(STDOUT,logFile)

            process = Process.run(  "crystal build #{ISM::Default::Filename::Task}.cr -o #{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}",
                                    output: logWriter,
                                    error: logWriter,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if !process.success?
                exitProgram
            end

            process = Process.run(  "./#{ISM::Default::Filename::Task}",
                                    output: logWriter,
                                    error: logWriter,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            logFile.close

            if !process.success?
                exitProgram
            end

            cleanBuildingDirectory(@settings.rootPath+software.builtSoftwareDirectoryPath)
        end

        def runUninstallationProcess(software : ISM::SoftwareDependency)
            tasks = generateUninstallTasks(software)
            generateTasksFile(tasks)

            process = Process.run(  "crystal build #{ISM::Default::Filename::Task}.cr -o #{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if !process.success?
                exitProgram
            end

            process = Process.run(  "./#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: "#{@settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}")

            if !process.success?
                exitProgram
            end
        end

        def generateInstallTasks(software : ISM::SoftwareDependency) : String
            tasks = <<-CODE
                    #{getRequiredLibraries}
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase
                    {{ read_file("#{software.requireFilePath}").id }}
                    target = Target.new("#{software.filePath}")
                    #{getEnabledOptions(software)}
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
                        target.showInformations
                    rescue
                        Ism.exitProgram
                    end

                    CODE

            return tasks
        end

        def generateShowInformationTasks(software : ISM::SoftwareDependency) : String
            tasks = <<-CODE
                    #{getRequiredLibraries}
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase
                    {{ read_file("#{software.requireFilePath}").id }}
                    target = Target.new("#{software.filePath}")
                    #{getEnabledOptions(software)}
                    begin
                        target.showInformations
                    rescue
                        Ism.exitProgram
                    end

                    CODE

            return tasks
        end

        def generateUninstallTasks(software : ISM::SoftwareDependency) : String
            tasks = <<-CODE
                    #{getRequiredLibraries}
                    Ism = ISM::CommandLine.new
                    Ism.loadSettingsFiles
                    Ism.loadSoftwareDatabase
                    Ism.loadInstalledSoftwareDatabase
                    {{ read_file("#{software.requireFilePath}").id }}
                    target = Target.new("#{software.filePath}")
                    #{getEnabledOptions(software)}
                    begin
                        target.recordUnneededKernelFeatures
                        target.uninstall
                    rescue
                        Ism.exitProgram
                    end

                    CODE

            return tasks
        end

        def generateTasksFile(tasks : String)
            File.write("#{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory}#{ISM::Default::Filename::Task}.cr", tasks)
        end

        def getNeededSoftwares : Array(ISM::SoftwareDependency)
            dependencyTable = getDependenciesTable(@requestedSoftwares)
            return getSortedDependencies(dependencyTable)
        end

        def getUnneededSoftwares : Array(ISM::SoftwareDependency)
            requiredDependencies = Hash(String,ISM::SoftwareDependency).new
            requestedSoftwaresHash = Hash(String,ISM::SoftwareDependency).new
            uneededSoftwares = Hash(String,ISM::SoftwareDependency).new
            multipleVersionSoftwaresHash = Hash(String,Array(ISM::SoftwareDependency)).new
            favouriteSoftwares = Array(String).new

            #Make an array of all recorded favourite softwares
            @favouriteGroups.each do |group|
                favouriteSoftwares = (favouriteSoftwares + group.softwares).uniq
            end

            #Make hash of the installed softwares
            @installedSoftwares.each do |software|
                playCalculationAnimation

                softwareDependency = software.toSoftwareDependency

                requiredDependencies[softwareDependency.hiddenName] = softwareDependency
            end

            #Make hash of the requested softwares for uninstallation (with dependencies)
            @requestedSoftwares.each do |software|
                playCalculationAnimation

                softwareDependency = software.toSoftwareDependency

                requestedSoftwaresHash[softwareDependency.hiddenName] = softwareDependency

                software.dependencies.each do |dependency|
                    playCalculationAnimation

                    if !favouriteSoftwares.includes?(dependency.versionName) || favouriteSoftwares.includes?(dependency.versionName) && @requestedSoftwares.any? { |entry| entry.versionName == dependency.versionName }
                        requestedSoftwaresHash[dependency.hiddenName] = dependency
                    end

                end
            end

            #Remove requested softwares for removal from the required dependencies
            requestedSoftwaresHash.keys.each do |key|
                playCalculationAnimation

                requiredDependencies.delete(key)
            end

            #Double check if we are not gonna remove needed dependencies for the system
            requiredDependencies.values.each do |requiredSoftware|
                playCalculationAnimation

                #Generate as well the multiple versions hash
                if !multipleVersionSoftwaresHash.has_key?(requiredSoftware.name)
                    multipleVersionSoftwaresHash[requiredSoftware.name] = [requiredSoftware]
                else
                    multipleVersionSoftwaresHash[requiredSoftware.name].push(requiredSoftware)
                end

                requiredSoftware.dependencies.each do |dependency|
                    playCalculationAnimation

                    requiredDependencies[dependency.hiddenName] = dependency
                end
            end

            #Check if same software with differents versions are all needed
            multipleVersionSoftwaresHash.values.each do |versions|
                playCalculationAnimation

                versions.each do |version|
                    playCalculationAnimation

                    needed = false

                    requiredDependencies.values.each do |requiredDependency|
                        playCalculationAnimation

                        requiredDependency.dependencies.each do |dependency|
                            playCalculationAnimation

                            if version.hiddenName == dependency.hiddenName
                                needed = true
                                break
                            end
                        end

                    end

                    if !needed
                        uneededSoftwares[version.hiddenName] = version
                        requiredDependencies.delete(version.hiddenName)
                    end

                end

            end

            wrongArguments = Array(String).new

            @requestedSoftwares.each do |requestedSoftware|
                playCalculationAnimation

                requestedDependency = requestedSoftware.toSoftwareDependency

                if !requiredDependencies.has_key?(requestedDependency.hiddenName)
                    uneededSoftwares[requestedDependency.hiddenName] = requestedDependency

                    requestedSoftwaresHash.keys.each do |key|
                        playCalculationAnimation

                        if !requiredDependencies.has_key?(key)
                            uneededSoftwares[key] = requestedSoftwaresHash[key]
                        end

                        requiredDependencies.keys.each do |requiredKey|
                            playCalculationAnimation

                            requiredDependencies[requiredKey].dependencies.each do |dependency|
                                playCalculationAnimation

                                if dependency.hiddenName == requestedDependency.hiddenName && !wrongArguments.includes?(requestedDependency.hiddenName)
                                    wrongArguments.push(requestedDependency.hiddenName)
                                end
                            end

                        end
                    end
                end
            end

            if !wrongArguments.empty?
                showCalculationDoneMessage
                showSoftwareNeededMessage(wrongArguments)
                exitProgram
            end

            return uneededSoftwares.values
        end

        def getSoftwaresToUpdate : Array(ISM::SoftwareInformation)
            softwareToUpdate = Array(String).new

            @installedSoftwares.each do |installedSoftware|

                playCalculationAnimation

                @softwares.each do |availableSoftware|

                    playCalculationAnimation

                    currentVersion = SemanticVersion.parse(installedSoftware.version)
                    greatestSoftware = availableSoftware.greatestVersion
                    greatestVersion = SemanticVersion.parse(greatestSoftware.version)

                    #Faire en sorte de renvoyer directement la dernière version avec les options nécessaires ?
                    if installedSoftware.name == availableSoftware.name
                        if currentVersion < greatestVersion && !softwareIsInstalled(greatestSoftware)
                            softwareToUpdate.push(installedSoftware.name)
                        else
                            #Ajouter les logiciels à jour mais nécessitant une mise à jour des options
                        end
                    end

                end

            end

            return getRequestedSoftwares(softwareToUpdate)
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
