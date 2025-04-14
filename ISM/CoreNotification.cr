module ISM

    module Core

        module Notification

            def self.failedToEnsureSecurityNotification
                puts "#{ISM::Default::CommandLine::FailedToEnsureSecurity.colorize(:red)}"
            end

            def self.needToBeRunAsNormalUserNotification
                puts "#{ISM::Default::CommandLine::NeedToBeRunAsNormalUserText.colorize(:yellow)}"
            end

            def self.needToBeRunAsMemberOfIsmGroupNotification
                puts "#{ISM::Default::CommandLine::NeedToBeRunAsMemberOfIsmGroupText.colorize(:yellow)}"
            end

            def self.errorUnknowArgument
                puts "#{ISM::Default::CommandLine::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                puts    "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                        "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                        "#{ISM::Default::CommandLine::ErrorUnknowArgumentHelp3.colorize(:white)}"
            end

            def self.processNotification(message : String)
                puts "#{ISM::Default::CommandLine::ProcessNotificationCharacters.colorize(:green)} #{message}"
            end

            def self.subProcessNotification(message : String)
                puts "\t#{ISM::Default::CommandLine::SubProcessNotificationCharacters.colorize(:green)} #{message}"
            end

            def self.errorNotification(message : String, error)
                puts
                puts "[#{"!".colorize(:red)}] #{message.colorize(Colorize::ColorRGB.new(255,100,100))}"

                if typeof(error) == Exception
                    puts "[#{"!".colorize(:red)}] "
                    puts "#{error.colorize(Colorize::ColorRGB.new(255,100,100))}"
                end
            end

            def self.internalErrorNotification(error : ISM::TaskBuildingProcessError)
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

            def self.installerImplementationErrorNotification(software : ISM::SoftwareInformation, error : ISM::TaskBuildingProcessError)
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

            def self.getFileContentError(filePath : String, error = nil)
                ISM::Core::Notification.errorNotification(ISM::Default::CommandLine::ErrorGetFileContentText+filePath, error)
            end

            def self.informationNotificationTitle(name : String, version : String)
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

            def self.informationNotification(message : String)
                puts "[#{"Info".colorize(:green)}] #{message}"
            end

            def self.informationCodeNotification(message : String)
                puts "#{message.colorize(:magenta).back(Colorize::ColorRGB.new(80, 80, 80))}"
            end

            def self.securityNotification(command : String ,reason : String, details : String)
                securityMessage = <<-MESSAGE
                #{ISM::Default::CommandLine::SecurityNotificationTitleText.colorize(:red)}\n"
                #{ISM::Default::CommandLine::SecurityNotificationCommandText} #{command.colorize(:magenta)}\n"
                #{ISM::Default::CommandLine::SecurityNotificationReasonText} #{reason.colorize(:yellow)}\n"
                #{ISM::Default::CommandLine::SecurityNotificationDetailsText} #{details.colorize(:green)}\n"
                MESSAGE

                ISM::Core.progressivePrint( text: "#{securityMessage}\n",
                                            delay: 1)
            end

            def self.chrootSecurityNotification
                ISM::Core::Notification.securityNotification(  command:    ISM::Default::CommandLine::ChrootSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::ChrootSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::ChrootSecurityNotificationDetailsText)
            end

            def self.prepareChrootDevConsoleSecurityNotification(command : String)
                ISM::Core::Notification.securityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootDevConsoleSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootDevConsoleSecurityNotificationDetailsText)
            end

            def self.prepareChrootDevNullSecurityNotification(command : String)
                ISM::Core::Notification.securityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootDevNullSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootDevNullSecurityNotificationDetailsText)
            end

            def self.prepareChrootDevSecurityNotification(command : String)
                ISM::Core::Notification.securityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootDevSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootDevSecurityNotificationDetailsText)
            end

            def self.prepareChrootDevPtsSecurityNotification(command : String)
                ISM::Core::Notification.securityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootDevPtsSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootDevPtsSecurityNotificationDetailsText)
            end

            def self.prepareChrootProcSecurityNotification(command : String)
                ISM::Core::Notification.securityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootProcSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootProcSecurityNotificationDetailsText)
            end

            def self.prepareChrootSysSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootSysSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootSysSecurityNotificationDetailsText)
            end

            def self.prepareChrootNetworkConfigurationSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareChrootNetworkConfigurationSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareChrootNetworkConfigurationSecurityNotificationDetailsText)
            end

            def self.prepareRootPermissionsSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::PrepareRootPermissionsSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::PrepareRootPermissionsSecurityNotificationDetailsText)
            end

            def self.stripInstalledFilesSecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::StripInstalledFilesSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::StripInstalledFilesSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::StripInstalledFilesSecurityNotificationDetailsText)
            end

            def self.installFileSecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::InstallFileSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::InstallFileSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::InstallFileSecurityNotificationDetailsText)
            end

            def self.installSymlinkSecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::InstallSymlinkSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::InstallSymlinkSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::InstallSymlinkSecurityNotificationDetailsText)
            end

            def self.installDirectorySecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::InstallDirectorySecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::InstallDirectorySecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::InstallDirectorySecurityNotificationDetailsText)
            end

            def self.uninstallFileSecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::UninstallFileSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::UninstallFileSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::UninstallFileSecurityNotificationDetailsText)
            end

            def self.uninstallDirectorySecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::UninstallDirectorySecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::UninstallDirectorySecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::UninstallDirectorySecurityNotificationDetailsText)
            end

            def self.generateEmptyPasswdFileSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::GenerateEmptyPasswdFileSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::GenerateEmptyPasswdFileSecurityNotificationDetailsText)
            end

            def self.runLocaledefCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunLocaledefCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunLocaledefCommandSecurityNotificationDetailsText)
            end

            def self.runDircolorsCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunDircolorsCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunDircolorsCommandSecurityNotificationDetailsText)
            end

            def self.runLdconfigCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunLdconfigCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunLdconfigCommandSecurityNotificationDetailsText)
            end

            def self.runPwconvCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunPwconvCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunPwconvCommandSecurityNotificationDetailsText)
            end

            def self.runGrpconvCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunGrpconvCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunGrpconvCommandSecurityNotificationDetailsText)
            end

            def self.runUdevadmCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunUdevadmCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunUdevadmCommandSecurityNotificationDetailsText)
            end

            def self.runZicCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunZicCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunZicCommandSecurityNotificationDetailsText)
            end

            def self.runInstallCatalogCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunInstallCatalogCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunInstallCatalogCommandSecurityNotificationDetailsText)
            end

            def self.runXmlCatalogCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunXmlCatalogCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunXmlCatalogCommandSecurityNotificationDetailsText)
            end

            def self.runInstallInfoCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunInstallInfoCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunInstallInfoCommandSecurityNotificationDetailsText)
            end

            def self.runMakeCaCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunMakeCaCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunMakeCaCommandSecurityNotificationDetailsText)
            end

            def self.runGtkQueryImmodules2CommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunGtkQueryImmodules2CommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunGtkQueryImmodules2CommandSecurityNotificationDetailsText)
            end

            def self.runGtkQueryImmodules3CommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunGtkQueryImmodules3CommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunGtkQueryImmodules3CommandSecurityNotificationDetailsText)
            end

            def self.runGlibCompileSchemasCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunGlibCompileSchemasCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunGlibCompileSchemasCommandSecurityNotificationDetailsText)
            end

            def self.runAlsactlCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunAlsactlCommandSecurityNotificatioReasonText,
                                            details:    ISM::Default::CommandLine::RunAlsactlCommandSecurityNotificatioDetailsText)
            end

            def self.runDbusUuidgenCommandSecurityNotification(command : String)
                ISM::Core::Notification.SecurityNotification(  command:    command,
                                            reason:     ISM::Default::CommandLine::RunDbusUuidgenCommandSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::RunDbusUuidgenCommandSecurityNotificationDetailsText)
            end

            def self.lockSystemAccessSecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::LockSystemAccessSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::LockSystemAccessSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::LockSystemAccessSecurityNotificationDetailsText)
            end

            def self.unlockSystemAccessSecurityNotification
                ISM::Core::Notification.SecurityNotification(  command:    ISM::Default::CommandLine::UnlockSystemAccessSecurityNotificationCommandText,
                                            reason:     ISM::Default::CommandLine::UnlockSystemAccessSecurityNotificationReasonText,
                                            details:    ISM::Default::CommandLine::UnlockSystemAccessSecurityNotificationDetailsText)
            end

            def self.download(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::DownloadText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.downloadAdditions
                ISM::Core::Notification.subProcessNotification("#{ISM::Default::CommandLine::DownloadAdditionsText.colorize(:green)}")
            end

            def self.check(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::CheckText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.checkAdditions
                ISM::Core::Notification.subProcessNotification("#{ISM::Default::CommandLine::CheckAdditionsText.colorize(:green)}")
            end

            def self.extract(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::ExtractText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.extractAdditions
                ISM::Core::Notification.subProcessNotification("#{ISM::Default::CommandLine::ExtractAdditionsText.colorize(:green)}")
            end

            def self.patch(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::PatchText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.localPatch(patchName : String)
                ISM::Core::Notification.subProcessNotification(ISM::Default::CommandLine::LocalPatchText+"#{patchName.colorize(:yellow)}")
            end

            def self.prepare(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::PrepareText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.configure(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::ConfigureText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.build(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::BuildText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.prepareInstallation(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::PrepareInstallationText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.install(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::InstallText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.unlockingSystemAccess
                ISM::Core::Notification.subProcessNotification(ISM::Default::CommandLine::UnlockingSystemAccessText)
            end

            def self.applyingSecurityMap
                ISM::Core::Notification.subProcessNotification(ISM::Default::CommandLine::ApplyingSecurityMapText)
            end

            def self.strippingFiles
                ISM::Core::Notification.subProcessNotification(ISM::Default::CommandLine::StrippingFilesText)
            end

            def self.deploy
                ISM::Core::Notification.subProcessNotification(ISM::Default::CommandLine::DeployText)
            end

            def self.lockingSystemAccess
                ISM::Core::Notification.subProcessNotification(ISM::Default::CommandLine::LockingSystemAccessText)
            end

            def self.updateKernelOptionsDatabase(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::UpdateKernelOptionsDatabaseText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.recordNeededKernelOptions
                kernelName = (ISM::Core.selectedKernel.name == "" ? ISM::Default::CommandLine::FuturKernelText : ISM::Core.selectedKernel.name )

                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::RecordNeededKernelOptionsText+"#{kernelName.colorize(:green)}")
            end

            def self.clean(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::CleanText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.uninstall(softwareInformation : ISM::SoftwareInformation)
                ISM::Core::Notification.processNotification(ISM::Default::CommandLine::UninstallText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.downloadError(link : String, error = nil)
                printErrorNotification(ISM::Default::CommandLine::ErrorDownloadText+link, error)
            end

            def self.connexionError(link : String, error = nil)
                printErrorNotification( ISM::Default::CommandLine::ErrorConnexionText1 +
                                        link +
                                        ISM::Default::CommandLine::ErrorConnexionText2,
                                        error)
            end

            def self.checkError(archive : String, sha512 : String, error = nil)
                printErrorNotification( ISM::Default::CommandLine::ErrorCheckText1 +
                                        archive +
                                        ISM::Default::CommandLine::ErrorCheckText2 +
                                        sha512, error)
            end

            def self.extractError(archivePath : String, destinationPath : String ,error = nil)
                printErrorNotification( ISM::Default::CommandLine::ErrorExtractText1 +
                                        archivePath +
                                        ISM::Default::CommandLine::ErrorExtractText2 +
                                        destinationPath,
                                        error)
            end

            def self.applyPatchError(patchName : String, error = nil)
                printErrorNotification(ISM::Default::CommandLine::ErrorApplyPatchText+patchName, error)
            end

            def self.copyFileError(path : String | Enumerable(String), targetPath : String, error = nil)
                if path.is_a?(Enumerable(String))
                    path = path.join(",")
                end
                printErrorNotification(ISM::Default::CommandLine::ErrorCopyFileText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorCopyFileText2 +
                                    targetPath, error)
            end

            def self.copyDirectoryError(path : String, targetPath : String, error = nil)
                printErrorNotification(ISM::Default::CommandLine::ErrorCopyDirectoryText1 +
                                    path +
                                    ISM::Default::CommandLine::ErrorCopyDirectoryText2 +
                                    targetPath, error)
            end

            def self.deleteFileError(path : String | Enumerable(String), error = nil)
                if path.is_a?(Enumerable(String))
                    path = path.join(",")
                end

                printErrorNotification(ISM::Default::CommandLine::ErrorDeleteFileText+path, error)
            end

            def self.moveFileError(path : String | Enumerable(String), newPath : String, error = nil)
                if path.is_a?(Enumerable(String))
                    path = path.join(",")
                end

                printErrorNotification( ISM::Default::CommandLine::ErrorMoveFileText1 +
                                        path +
                                        ISM::Default::CommandLine::ErrorMoveFileText2 +
                                        newPath, error)
            end

            def self.makeDirectoryError(directory : String, error = nil)
                printErrorNotification(ISM::Default::CommandLine::ErrorMakeDirectoryText+directory, error)
            end

            def self.deleteDirectoryError(directory : String, error = nil)
                printErrorNotification(ISM::Default::CommandLine::ErrorDeleteDirectoryText+directory, error)
            end

            def self.makeLinkUnknowTypeError(path : String, targetPath : String, linkType : Symbol, error = nil)
                printErrorNotification( ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText1 +
                                        path +
                                        ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText2 +
                                        targetPath +
                                        ISM::Default::CommandLine::ErrorMakeLinkUnknowTypeText3 +
                                        linkType.to_s, error)
            end

            def self.runSystemCommandError(arguments : String, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, error = nil)

                argumentText = "#{ISM::Default::CommandLine::ErrorRunSystemCommandText1}#{arguments.squeeze(" ")}"
                pathText = String.new
                environmentText = String.new
                environmentFilePathText = String.new

                if !path.empty?
                    pathText = "#{ISM::Default::CommandLine::ErrorRunSystemCommandText2}#{(Ism.settings.installByChroot ? Ism.settings.rootPath : "")}#{path}".squeeze("/")
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

            #TO IMPROVE: Pass the beginning of class generation to check if its class related problem
            def self.taskBuildingProcessErrorMessage(taskError : ISM::TaskBuildingProcessError, taskPath : String)
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
                    ISM::Core::Notification.internalErrorNotification(taskError)
                else
                #Related to target installer implementation
                    ISM::Core::Notification.installerImplementationErrorNotification(   software,
                                                                                        ISM::TaskBuildingProcessError.new(  file:       targetPath,
                                                                                                                            line:       realLineNumber,
                                                                                                                            column:     taskError.column,
                                                                                                                            size:       taskError.size,
                                                                                                                            message:    taskError.message))
                end
            end

            def self.noMatchFoundMessage(wrongArguments : Array(String))
                puts "#{ISM::Default::CommandLine::NoMatchFound}#{wrongArguments.join(", ").colorize(:green)}"
                puts ISM::Default::CommandLine::NoMatchFoundAdvice
                puts
                puts "#{ISM::Default::CommandLine::DoesntExistText.colorize(:green)}"
            end

            def self.softwareNotInstalledMessage(wrongArguments : Array(String))
                puts  "#{ISM::Default::CommandLine::SoftwareNotInstalled}#{wrongArguments.join(", ").colorize(:green)}"
                puts
                puts "#{ISM::Default::CommandLine::NotInstalledText.colorize(:green)}"
            end

            def self.noVersionAvailableMessage(wrongArguments : Array(String))
                puts "#{ISM::Default::CommandLine::NoVersionAvailable}#{wrongArguments.join(", ").colorize(:green)}"
                puts ISM::Default::CommandLine::NoVersionAvailableAdvice
                puts
                puts "#{ISM::Default::CommandLine::DoesntExistText.colorize(:green)}"
            end


            def self.noUpdateMessage
                puts "#{ISM::Default::CommandLine::NoUpdate.colorize(:green)}"
            end

            def self.noCleaningRequiredMessage
                puts "#{ISM::Default::CommandLine::NoCleaningRequiredMessage.colorize(:green)}"
            end

            def self.softwareNeededMessage(wrongArguments : Array(String))
                puts ISM::Default::CommandLine::SoftwareNeeded + "#{wrongArguments.join(", ").colorize(:green)}"
                puts
                puts "#{ISM::Default::CommandLine::NeededText.colorize(:green)}"
            end

            def self.skippedUpdatesMessage
                puts "#{ISM::Default::CommandLine::SkippedUpdatesText.colorize(:yellow)}"
                puts
            end

            def self.unavailableDependencyMessage(software : ISM::SoftwareInformation, dependency : ISM::SoftwareInformation, allowTitle = true)
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

            def self.ambiguousSearchMessage(matches : Array(String))
                names = String.new

                puts
                puts "#{ISM::Default::CommandLine::AmbiguousSearchTitle.colorize(:yellow)}"
                puts "\n"

                matches.each_with_index do |name, index|
                    names += "#{name.colorize(:red)}#{index < matches.size-1 ? ", " : "."}"
                end

                puts "#{ISM::Default::CommandLine::AmbiguousSearchText.colorize(:green)} #{names}"
            end

            def self.inextricableDependenciesMessage(dependencies : Array(ISM::SoftwareInformation))
                dependencyChains = Array(Array(ISM::SoftwareInformation)).new

                #For each codependent software we get first the full tree, and then generate the chain from it (excluding itself)
                dependencies.each do |dependency|
                    dependencyTree = dependency.dependencies(allowDeepSearch: true).map { |entry| entry.information}

                    dependencyTree.each_with_index do |software, softwareIndex|
                        if software != dependency
                            dependencyChains.push(dependencyTree[0..softwareIndex])
                        end
                    end
                end

                puts
                puts "#{ISM::Default::CommandLine::InextricableText.colorize(:yellow)}"
                puts "\n"

                #Now we print each chains with in highlight the first and last one
                dependencyChains.each do |chain|

                    chain.each_with_index do |software, index|
                        color = :magenta

                        case index
                        when 0
                            color = :green
                        when (chain.size - 1)
                            color = :red
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

            def self.missingSelectedDependenciesMessage(fullName : String, version : String, dependencySelection : Array(Array(String)))
                puts "#{ISM::Default::CommandLine::MissingSelectedDependenciesText.colorize(:yellow)}"
                puts "\n"

                puts "#{fullName.colorize(:magenta)}" + " /" + "#{version.colorize(Colorize::ColorRGB.new(255,100,100))}" + "/ "

                dependencySelection.each do |selection|
                    dependencySet = selection.map { |entry| "#{(entry[0..entry.index(":")])[0..-2].colorize(:red)}:#{entry.gsub(entry[0..entry.index(":")],"").colorize(:green)}" }

                    puts "\t#{ISM::Default::CommandLine::MissingSelectionText.colorize(:magenta)} #{dependencySet.join(" | ")}"
                end

                puts "\n"
            end

            def self.taskCompilationTitleMessage
                puts
                print "#{ISM::Default::CommandLine::TaskCompilationText}"
            end

            def self.taskCompilationFailedMessage
                Ism.cleanCalculationAnimation
                print "#{ISM::Default::CommandLine::TaskCompilationFailedText.colorize(Colorize::ColorRGB.new(255,100,100))}\n"
            end

            def self.calculationDoneMessage
                Ism.cleanCalculationAnimation
                print "#{ISM::Default::CommandLine::CalculationDoneText.colorize(:green)}\n"
            end

            def self.calculationTitleMessage
                puts
                print "#{ISM::Default::CommandLine::CalculationTitle}"
            end

            def self.softwares(neededSoftwares : Array(ISM::SoftwareInformation), mode = :installation)
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

                            status = Ism.getSoftwareStatus(software)

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

            def self.installationQuestion(softwareNumber : Int32)
                summaryText = softwareNumber.to_s + ISM::Default::CommandLine::InstallSummaryText + "\n"

                puts "#{summaryText.colorize(:green)}"

                print   "#{ISM::Default::CommandLine::InstallQuestion}" +
                        "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                        "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
            end

            def self.uninstallationQuestion(softwareNumber : Int32)
                summaryText = softwareNumber.to_s + ISM::Default::CommandLine::UninstallSummaryText + "\n"

                puts "#{summaryText.colorize(:green)}"

                print   "#{ISM::Default::CommandLine::UninstallQuestion.colorize}" +
                        "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                        "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
            end

            def self.updateQuestion(softwareNumber : Int32)
                summaryText = softwareNumber.to_s + ISM::Default::CommandLine::UpdateSummaryText + "\n"

                puts "#{summaryText.colorize(:green)}"

                print   "#{ISM::Default::CommandLine::UpdateQuestion.colorize.mode(:underline)}" +
                        "[" + "#{ISM::Default::CommandLine::YesReplyOption.colorize(:green)}" +
                        "/" + "#{ISM::Default::CommandLine::NoReplyOption.colorize(:red)}" + "]"
            end

            def self.separator
                puts "\n"
                puts "#{ISM::Default::CommandLine::Separator.colorize(:green)}\n"
                puts "\n"
            end

            def self.endSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
                puts
                puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)}#{passNumber == 0 ? "" : " (Pass#{passNumber})".colorize(:yellow)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                        " #{ISM::Default::CommandLine::InstalledText} " +
                        "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                        " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                        "#{">>".colorize(:light_magenta)}" +
                        "\n"
            end

            def self.endSoftwareUninstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
                puts
                puts    "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                        " #{ISM::Default::CommandLine::UninstalledText} " +
                        "["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                        " / "+"#{limit.to_s.colorize(:light_red)}"+"] " +
                        "#{">>".colorize(:light_magenta)}" +
                        "\n"
            end

            def self.installationDetailsMessage(softwareNumber : UInt32)
                title = ISM::Default::CommandLine::InstallationDetailsText
                limit = title.size

                separatorText = String.new

                (0..limit).each do |index|
                    separatorText += "="
                end

                separatorText = "#{separatorText.colorize(:green)}\n"

                puts
                puts    separatorText +
                        "#{title.colorize(:green)}\n" +
                        separatorText +
                        "#{ISM::Default::CommandLine::NewSoftwareNumberDetailText.colorize(:green)}: #{softwareNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                        "#{ISM::Default::CommandLine::NewDirectoryNumberDetailText.colorize(:green)}: #{Ism.totalInstalledDirectoryNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                        "#{ISM::Default::CommandLine::NewSymlinkNumberDetailText.colorize(:green)}: #{Ism.totalInstalledSymlinkNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                        "#{ISM::Default::CommandLine::NewFileNumberDetailText.colorize(:green)}: #{Ism.totalInstalledFileNumber.colorize(Colorize::ColorRGB.new(255,100,100))}\n" +
                        "#{ISM::Default::CommandLine::InstalledSizeDetailText.colorize(:green)}: #{Ism.totalInstalledSize.humanize_bytes.colorize(Colorize::ColorRGB.new(255,100,100))}\n"
                puts
            end

            def self.startSoftwareInstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String, passNumber = 0)
                puts    "#{"<<".colorize(:light_magenta)}" +
                        " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                        " / #{limit.to_s.colorize(:light_red)}" +
                        "] #{ISM::Default::CommandLine::InstallingText} " +
                        "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)}#{passNumber == 0 ? "" : " (Pass#{passNumber})".colorize(:yellow)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                        "\n\n"
            end

            def self.startSoftwareUninstallingMessage(index : Int32, limit : Int32, port : String, name : String, version : String)
                puts    "\n#{"<<".colorize(:light_magenta)}" +
                        " ["+"#{(index+1).to_s.colorize(Colorize::ColorRGB.new(255,170,0))}" +
                        " / #{limit.to_s.colorize(:light_red)}" +
                        "] #{ISM::Default::CommandLine::UninstallingText} " +
                        "#{"@#{port}".colorize(:red)}:#{name.colorize(:green)} /#{version.colorize(Colorize::ColorRGB.new(255,100,100))}/" +
                        "\n\n"
            end

        end

    end

end
