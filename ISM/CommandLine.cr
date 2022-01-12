module ISM

    class CommandLine

        property options : Array(ISM::CommandLineOption)
        property settings : ISM::CommandLineSettings
        property systemSettings : ISM::CommandLineSystemSettings
        property softwares : Array(ISM::AvailableSoftware)
        property installedSoftwares : Array(ISM::SoftwareInformation)
        property ports : Array(ISM::Port)
        property version : ISM::Version

        def initialize
            @options = ISM::Default::CommandLine::Options
            @settings = ISM::CommandLineSettings.new
            @systemSettings = ISM::CommandLineSystemSettings.new
            @softwares = Array(ISM::AvailableSoftware).new
            @installedSoftwares = Array(ISM::SoftwareInformation).new
            @ports = Array(ISM::Port).new
            @version = ISM::Version.new
        end

        def start
            loadSoftwareDatabase
            loadPortsDatabase
            loadSettingsFiles
            version.loadVersionFile
            checkEnteredArguments
        end

        def loadSoftwareDatabase
            portDirectories = Dir.children(ISM::Default::Path::SoftwaresDirectory).reject!("SoftwaresLibrairies.cr")

            portDirectories.each do |portDirectory|
                portSoftwareDirectories = Dir.children(ISM::Default::Path::SoftwaresDirectory+portDirectory).reject!(&.starts_with?(".git"))

                portSoftwareDirectories.each do |softwareDirectory|
                    versionDirectories = Dir.children(  ISM::Default::Path::SoftwaresDirectory+portDirectory + "/" +
                                                        softwareDirectory)
                    softwaresInformations = Array(ISM::SoftwareInformation).new

                    versionDirectories.each do |versionDirectory|

                        softwareInformation = ISM::SoftwareInformation.new

                        if File.exists?(ISM::Default::Path::SettingsSoftwaresDirectory +
                                        portDirectory+ "/" +
                                        softwareDirectory + "/" +
                                        versionDirectory + "/" +
                                        ISM::Default::Filename::SoftwareSettings)
                            softwareInformation.loadInformationFile(ISM::Default::Path::SettingsSoftwaresDirectory +
                                                                    portDirectory+ "/" +
                                                                    softwareDirectory + "/" +
                                                                    versionDirectory + "/" +
                                                                    ISM::Default::Filename::SoftwareSettings)
                            
                        else
                            softwareInformation.loadInformationFile(ISM::Default::Path::SoftwaresDirectory +
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
            if !Dir.exists?(ISM::Default::Path::PortsDirectory)
                Dir.mkdir(ISM::Default::Path::PortsDirectory)
            end

            portsFiles = Dir.children(ISM::Default::Path::PortsDirectory)

            portsFiles.each do |portFile|
                port = ISM::Port.new
                port.loadPortFile(ISM::Default::Path::PortsDirectory+portFile)
                @ports << port
            end
        end

        def loadSettingsFiles
            if File.exists?(ISM::Default::CommandLineSettings::SettingsFilePath)
                @settings.loadSettingsFile
            else
                @settings.writeSettingsFile
            end

            if File.exists?(ISM::Default::CommandLineSystemSettings::SystemSettingsFilePath)
                @systemSettings.loadSystemSettingsFile
            else
                @systemSettings.writeSystemSettingsFile
            end
        end

        def checkEnteredArguments
            if ARGV.empty? || ARGV[0] == ISM::Default::Option::Help::ShortText || ARGV[0] == ISM::Default::Option::Help::LongText
                showHelp
            else
                matchingOption = false

                @options.each_with_index do |argument, index|
                    if ARGV[0] == argument.shortText || ARGV[0] == argument.longText
                        matchingOption = true
                        @options[index].start
                        break
                    end
                end

                if !matchingOption
                    showErrorUnknowArgument
                end
            end
        end

        def showHelp
            puts ISM::Default::CommandLine::Title
            @options.each do |argument|
                puts    "\t" + "#{argument.shortText.colorize(:white)}" +
                        "\t" + "#{argument.longText.colorize(:white)}" +
                        "\t" + "#{argument.description.colorize(:green)}"
            end
        end

        def showErrorUnknowArgument
            puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
            puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
        end

        def printProcessNotification(message : String)
            puts "#{"* ".colorize(:green)}" + message
        end

        def printErrorNotification(message : String)
            puts "[" + "#{"!".colorize(:red)}" + "] " + message
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
        
        def notifyOfInstall(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::InstallText+softwareInformation.name)
        end

        def notifyOfClean(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::CleanText+softwareInformation.name)
        end
        
        def notifyOfUninstall(softwareInformation : ISM::SoftwareInformation)
            printProcessNotification(ISM::Default::CommandLine::UninstallText+softwareInformation.name)
        end

        def notifyOfDownloadError(link : String)
            printErrorNotification(ISM::Default::CommandLine::ErrorDownloadText+link)
        end

        def notifyOfExtractError(archiveName : String)
            printErrorNotification(ISM::Default::CommandLine::ErrorExtractText+archiveName)
        end

        def notifyOfApplyPatchError(patchName : String)
            printErrorNotification(ISM::Default::CommandLine::ErrorApplyPatchText+patchName)
        end

        def notifyOfConfigureError(sourceName : String)
            printErrorNotification(ISM::Default::CommandLine::ErrorConfigureText+sourceName)
        end

        def notifyOfMakeError(path : String)
            printErrorNotification(ISM::Default::CommandLine::ErrorMakeText+path)
        end

        def notifyOfMoveFileError(path : String, newPath : String)
            printErrorNotification( ISM::Default::CommandLine::ErrorMoveFileText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorMoveFileText2 +
                                    newPath)
        end

        def notifyOfMakeDirectoryError(directory : String)
            printErrorNotification(ISM::Default::CommandLine::ErrorMakeDirectoryText+directory)
        end

    end

end
