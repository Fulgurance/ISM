module ISM

    class CommandLine

        property debugLevel : Int32
        property options : Array(ISM::CommandLineOption)
        property settings : ISM::CommandLineSettings
        property systemSettings : ISM::CommandLineSystemSettings
        property softwares : Array(ISM::AvailableSoftware)
        property installedSoftwares : Array(ISM::SoftwareInformation)
        property ports : Array(ISM::Port)
        property portsSettings : ISM::CommandLinePortsSettings


        def initialize
            @debugLevel = ISM::Default::CommandLine::DebugLevel
            @options = ISM::Default::CommandLine::Options
            @settings = ISM::CommandLineSettings.new
            @systemSettings = ISM::CommandLineSystemSettings.new
            @softwares = Array(ISM::AvailableSoftware).new
            @installedSoftwares = Array(ISM::SoftwareInformation).new
            @ports = Array(ISM::Port).new
            @portsSettings = ISM::CommandLinePortsSettings.new
            @terminalTitleSaved = false
        end

        def start
            loadSettingsFiles
            loadSoftwareDatabase
            loadInstalledSoftwareDatabase
            loadPortsDatabase
            checkEnteredArguments
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

        def loadSettingsFiles
            @settings.loadSettingsFile
            @systemSettings.loadSystemSettingsFile
            @portsSettings.loadPortsSettingsFile
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

        def addInstalledSoftware(softwareInformation : ISM::SoftwareInformation, installedFiles : Array(String))
            softwareInformation.installedFiles = installedFiles

            softwareInformation.writeInformationFile(softwareInformation.installedFilePath)
        end

        def removeInstalledSoftware(installedSoftware : ISM::SoftwareInformation)

        end

        def softwareIsInstalled(software : ISM::SoftwareInformation) : Bool
            @installedSoftwares.each do |installedSoftware|
                if software.name == installedSoftware.name && software.version == installedSoftware.version
                    equalScore = 0

                    software.options.each do |option|

                        if installedSoftware.options.includes?(option)
                            equalScore += 1
                        else
                            installedOptionPass = installedSoftware.getEnabledPass

                            if option.isPass && installedOptionPass != ""

                                optionEnabledPassNumber = software.getEnabledPass.gsub("Pass","").to_i
                                optionPassNumber = option.name.gsub("Pass","").to_i
                                installedOptionPassNumber = installedOptionPass.gsub("Pass","").to_i

                                if installedOptionPassNumber > optionPassNumber || installedOptionPassNumber > optionEnabledPassNumber
                                    if installedOptionPass != option.name && option.active || installedOptionPass == option.name && !option.active
                                       equalScore += 1
                                    end
                                else
                                    return false
                                end
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

        def getSoftwareInformation(versionName : String) : ISM::SoftwareInformation
            result = ISM::SoftwareInformation.new

            @softwares.each do |entry|

                if entry.name.downcase == versionName.downcase
                    result.name = entry.name
                    if !entry.versions.empty?
                        temporary = entry.versions.last.clone
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
            puts "#{"* ".colorize(:green)}#{message}"
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

        def notifyOfClean(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::CleanText+softwareInformation.name)
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

        def notifyOfRunScriptError(file : String, path : String, error = nil)
            printErrorNotification( ISM::Default::CommandLine::ErrorRunScriptText1 +
                                    file +
                                    ISM::Default::CommandLine::ErrorRunScriptText2 +
                                    path, error)
        end

        def notifyOfRunPythonScriptError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunPythonScriptText+path, error)
        end

        def notifyOfRunCrystalCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunPythonScriptText+path, error)
        end

        def notifyOfRunPwconvCommandError(arguments : Array(String), error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunCrystalCommandText+arguments.join(" "), error)
        end

        def notifyOfRunGrpconvCommandError(arguments : Array(String), error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunRunGrpconvCommandText+arguments.join(" "), error)
        end

        def notifyOfRunUdevadmCommandError(arguments : Array(String), error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunUdevadmCommandText+arguments.join(" "), error)
        end

        def notifyOfRunMakeinfoCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunMakeinfoCommandText+path, error)
        end

        def notifyOfRunInstallInfoCommandError(arguments : Array(String), error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunInstallInfoCommandText+arguments.join(" "), error)
        end

        def notifyOfRunAutoreconfCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunAutoreconfCommandText+path, error)
        end

        def notifyOfRunLocaledefCommandError(arguments : Array(String), error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunLocaledefCommandText+arguments.join(" "), error)
        end

        def notifyOfRunGunzipCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunGunzipCommandText+path, error)
        end

        def notifyOfRunCmakeCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunCmakeCommandText+path, error)
        end

        def notifyOfRunMesonCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunMesonCommandText+path, error)
        end

        def notifyOfRunNinjaCommandError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunNinjaCommandText+path, error)
        end

        def notifyOfRunMakeCaCommandError(arguments : Array(String), error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorRunMakeCaCommandText+arguments.join(" "), error)
        end

        def notifyOfConfigureError(sourceName : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorConfigureText+sourceName, error)
        end

        def notifyOfMakePerlSourceError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorMakePerlSourceText+path, error)
        end

        def notifyOfMakeSourceError(path : String, error = nil)
            printErrorNotification(ISM::Default::CommandLine::ErrorMakeSourceText+path, error)
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

        def playCalculationAnimation(calculationStartingTime, frameIndex, reverseAnimation, text)
            currentTime = Time.monotonic

            if (currentTime - calculationStartingTime).milliseconds > 40
                if frameIndex == text.size && !reverseAnimation
                    reverseAnimation = true
                end

                if frameIndex < 1
                    reverseAnimation = false
                end

                if reverseAnimation
                    print "\033[1D"
                    print " "
                    print "\033[1D"
                    frameIndex -= 1
                end

                if !reverseAnimation
                    print "#{text[frameIndex].colorize(:green)}"
                    frameIndex += 1
                end

                calculationStartingTime = Time.monotonic
            end

            return calculationStartingTime, frameIndex, reverseAnimation
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
            if !@terminalTitleSaved
                STDOUT << "\e[22t"
                @terminalTitleSaved = true
            end
            STDOUT << "\e]0; #{title}\e\\"
        end

        def resetTerminalTitle
            STDOUT << "\e[23t"
        end

    end

end
