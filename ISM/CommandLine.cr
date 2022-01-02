module ISM

    class CommandLine

        property options : Array(ISM::CommandLineOption)
        property settings : ISM::CommandLineSettings
        property systemSettings : ISM::CommandLineSystemSettings
        property softwares : Array(ISM::AvailableSoftware)
        property installedSoftwares : Array(ISM::SoftwareInformation)
        property version : ISM::Version

        def initialize
            @options = ISM::Default::CommandLine::Options
            @settings = ISM::CommandLineSettings.new
            @systemSettings = ISM::CommandLineSystemSettings.new
            @softwares = Array(ISM::AvailableSoftware).new
            @installedSoftwares = Array(ISM::SoftwareInformation).new
            @version = ISM::Version.new
        end

        def start
            loadSoftwareDatabase
            loadSettingsFiles
            version.loadVersionFile
            checkEnteredArguments
        end

        def loadSoftwareDatabase
            if !Dir.exists?(ISM::Default::Path::SoftwaresDirectory)
                Dir.mkdir(ISM::Default::Path::SoftwaresDirectory)
            end
            
            softwareDirectories = Dir.children(ISM::Default::Path::SoftwaresDirectory).reject!(&.starts_with?(".git"))
            softwareDirectories.delete("SoftwaresLibrairies.cr")

            softwareDirectories.each do |softwareDirectory|
                versionDirectories = Dir.children(ISM::Default::Path::SoftwaresDirectory+softwareDirectory)
                softwaresInformations = Array(ISM::SoftwareInformation).new

                versionDirectories.each do |versionDirectory|

                    softwareInformation = ISM::SoftwareInformation.new

                    if File.exists?(ISM::Default::Path::SettingsSoftwaresDirectory +
                                    softwareDirectory + "/" +
                                    versionDirectory + "/" +
                                    ISM::Default::Filename::SoftwareSettings)
                        softwareInformation.loadInformationFile(ISM::Default::Path::SettingsSoftwaresDirectory +
                                                                softwareDirectory + "/" +
                                                                versionDirectory + "/" +
                                                                ISM::Default::Filename::SoftwareSettings)
                        
                    else
                        softwareInformation.loadInformationFile(ISM::Default::Path::SoftwaresDirectory +
                                                                softwareDirectory + "/" +
                                                                versionDirectory + "/" +
                                                                ISM::Default::Filename::Information)
                    end

                    softwaresInformations << softwareInformation
    
                end

                @softwares << ISM::AvailableSoftware.new(softwareDirectory,
                softwaresInformations)

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

        def notifyOfDownload(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::DownloadText +
                    softwareInformation.name
        end
        
        def notifyOfCheck(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::CheckText +
                    softwareInformation.name
        end
        
        def notifyOfExtract(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::ExtractText +
                    softwareInformation.name
        end
        
        def notifyOfPatch(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::PatchText +
                    softwareInformation.name
        end

        def notifyOfPrepare(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::PrepareText +
                    softwareInformation.name
        end
        
        def notifyOfConfigure(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::ConfigureText +
                    softwareInformation.name
        end
        
        def notifyOfBuild(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::BuildText +
                    softwareInformation.name
        end
        
        def notifyOfInstall(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::InstallText +
                    softwareInformation.name
        end

        def notifyOfClean(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::CleanText +
                    softwareInformation.name
        end
        
        def notifyOfUninstall(softwareInformation : ISM::SoftwareInformation)
            puts    "#{"* ".colorize(:green)}" +
                    ISM::Default::CommandLine::UninstallText +
                    softwareInformation.name
        end

    end

end
