module ISM

    module Core

        module Notification

            module Default

                RanAsSuperUserText = "ISM can't be run as root. Operation aborted."
                NotRanAsMemberOfIsmGroupText = "The current user is not in the #{CommandLine::Default::Name} group (id: #{Core::Security::Default::Id.to_s}). Operation aborted."
                ErrorUnknowArgument = "ISM error: unknow argument "
                ErrorUnknowArgumentHelp1 = "Use "
                ErrorUnknowArgumentHelp2 = "ism --help "
                ErrorUnknowArgumentHelp3 = "to learn how to use ISM"
                ProcessNotificationCharacters = "■"
                InternalErrorTitle = "Internal error"
                InstallerImplementationErrorTitle = "Software installer implementation error"
                InstallerImplementationErrorText1 = "The installer for the software "
                InstallerImplementationErrorText2 = " encountered an error at line number "
                InstallerImplementationErrorNotificationHelp = "ISM raised that error because the task cannot be compiled. That mean the related installer need to be fix."
                TaskBuildingProcessErrorText1 = "The ISM task at "
                TaskBuildingProcessErrorText2 = " encountered an error at line number "
                TaskBuildingErrorNotificationHelp = "ISM raised that error because the task cannot be compiled. That mean probably the task building process need to be fix."
                SetupChrootPermissionsText = "Setting default permissions for the targeted system"
                PrepareChrootProcText = "Mounting /proc in the targeted system"
                PrepareChrootSysText = "Mounting /sys in the targeted system"
                PrepareChrootProcDev = "Mounting /dev in the targeted system"
                PrepareChrootRunText = "Mounting /run in the targeted system"
                PrepareChrootNetworkText = "Copying network details in the targeted system"
                DownloadText = "Downloading "
                DownloadAdditionsText = "Downloading additions"
                CheckText = "Checking "
                CheckAdditionsText = "Checking additions"
                CheckIntegrityText = "Checking files integrity"
                CheckAuthenticityText = "Checking files authenticity"
                CheckIntegrityFileText = "Checking integrity for"
                CheckAuthenticityFileText = "Checking authenticity for"
                ExtractText = "Extracting "
                ExtractAdditionsText = "Extracting additions"
                PatchText = "Patching "
                LocalPatchText = "Applying local patch added by the user "
                PrepareText =  "Preparing "
                ConfigureText = "Configuring "
                BuildText = "Building "
                PrepareInstallationText = "Preparing installation for "
                StripFilesText = "Stripping files"
                DeployText = "Deploying"
                UpdateSystemCacheText = "Updating system caches"
                InstallText = "Installing "
                RecordNeededKernelOptionsText = "Recording needed kernel options for "
                CleanText = "Cleaning "
                FuturKernelText = "future kernel (not installed yet)"
                UpdateKernelOptionsDatabaseText = "Updating kernel options database for "
                UninstallText = "Uninstalling "
                ErrorDownloadText = "Failed to download from "
                ErrorRunSystemCommandText1 = "Failed to run "
                ErrorRunSystemCommandText2 = " in "
                ErrorRunSystemCommandText3 = " with given environment "
                ErrorRunSystemCommandText4 = " with the loaded environment file "
                ErrorRunSystemCommandUnknownError = "ISM encountered an error with the last executed command, but was not able to record it. The reason is unknown."

            end

            def self.ranAsSuperUserError
                puts "#{Default::RanAsSuperUserText.colorize(:yellow)}"
            end

            def self.notRanAsMemberOfIsmGroupError
                puts "#{Default::NotRanAsMemberOfIsmGroupText.colorize(:yellow)}"
            end

            def self.unknownArgumentError
                puts "#{Default::ErrorUnknowArgument.colorize(:yellow)}" + "#{ARGV[0].colorize(:white)}"
                puts    "#{Default::ErrorUnknowArgumentHelp1.colorize(:white)}" +
                        "#{Default::ErrorUnknowArgumentHelp2.colorize(:green)}" +
                        "#{Default::ErrorUnknowArgumentHelp3.colorize(:white)}"
            end

            def self.runningProcess(message : String)
                puts "#{Default::ProcessNotificationCharacters.colorize(:green)} #{message}"
            end

            def self.runningSubProcess(message : String)
                puts "\t#{"|".colorize(:green)} #{message}"
            end

            def self.error(message : String, error)
                puts
                puts "[#{"!".colorize(:red)}] #{message.colorize(Colorize::ColorRGB.new(255,100,100))}"

                if typeof(error) == Exception
                    puts "[#{"!".colorize(:red)}] "
                    puts "#{error.colorize(Colorize::ColorRGB.new(255,100,100))}"
                end
            end

            def self.internalError(error : ISM::TaskBuildingProcessError)
                title = "#{Default::InternalErrorTitle.colorize(:red)}"
                errorText = "#{Default::TaskBuildingProcessErrorText1}#{error.file}#{Default::TaskBuildingProcessErrorText2}#{error.line.to_s}".colorize(Colorize::ColorRGB.new(255,100,100))
                errorMessage = "#{error.message}".colorize(Colorize::ColorRGB.new(255,100,100))
                help = "\n#{Default::TaskBuildingErrorNotificationHelp.colorize(:red)}"

                errorReport = <<-REPORT
                [ #{title} ]

                #{errorText}

                #{errorMessage}

                #{help}
                REPORT

                puts "\n#{errorReport}\n"
            end

            def self.installerImplementationError(software : Software::Information, error : ISM::TaskBuildingProcessError)
                errorText1 = "#{Default::InstallerImplementationErrorText1.colorize(Colorize::ColorRGB.new(255,100,100))}"
                softwareText = "#{"@#{software.port}".colorize(:red)}:#{software.name.colorize(:green)} /#{software.version.colorize(Colorize::ColorRGB.new(255,100,100))}/"
                errorText2 = "#{Default::InstallerImplementationErrorText2}#{error.line.to_s}:".colorize(Colorize::ColorRGB.new(255,100,100))

                title = "#{Default::InstallerImplementationErrorTitle.colorize(:red)}"
                errorText = "#{errorText1}#{softwareText}#{errorText2}"
                errorMessage = "#{error.message.colorize(:yellow)}"
                help = "\n#{Default::InstallerImplementationErrorNotificationHelp.colorize(:red)}"

                errorReport = <<-REPORT
                [ #{title} ]

                #{errorText}

                #{errorMessage}

                #{help}
                REPORT

                puts "\n#{errorReport}\n"
            end

            def self.informationsTitle(name : String, version : String)
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

            def self.information(message : String)
                puts "[#{"Info".colorize(:green)}] #{message}"
            end

            def self.informationCode(message : String)
                puts "#{message.colorize(:magenta).back(Colorize::ColorRGB.new(80, 80, 80))}"
            end

            def self.download(softwareInformation : Software::Information)
                runningProcess(Default::DownloadText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.downloadAdditions
                runningProcess(Default::DownloadAdditionsText)
            end

            def self.setupChrootPermissions
                runningSubProcess(Default::SetupChrootPermissionsText)
            end

            def self.prepareChrootProc
                runningSubProcess(Default::PrepareChrootProcText)
            end

            def self.prepareChrootSys
                runningSubProcess(Default::PrepareChrootSysText)
            end

            def self.prepareChrootDev
                runningSubProcess(Default::PrepareChrootProcDev)
            end

            def self.prepareChrootRun
                runningSubProcess(Default::PrepareChrootRunText)
            end

            def self.prepareChrootNetwork
                runningSubProcess(Default::PrepareChrootNetworkText)
            end

            def self.check(softwareInformation : Software::Information)
                runningProcess(Default::CheckText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.checkIntegrity
                runningSubProcess("#{Default::CheckIntegrityText.colorize(:green)}")
            end

            def self.checkAuthenticity
                runningSubProcess("#{Default::CheckAuthenticityText.colorize(:green)}")
            end

            def self.checkIntegrityFile(file : String)
                runningSubProcess(Default::CheckIntegrityFileText+" #{file.colorize(:green)}")
            end

            def self.checkAuthenticityFile(file : String)
                runningSubProcess(Default::CheckAuthenticityFileText+" #{file.colorize(:green)}")
            end

            def self.extract(softwareInformation : Software::Information)
                runningProcess(Default::ExtractText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.extractAdditions
                runningProcess(Default::ExtractAdditionsText)
            end

            def self.patch(softwareInformation : Software::Information)
                runningProcess(Default::PatchText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.localPatch(patchName : String)
                runningSubProcess(Default::LocalPatchText+"#{patchName.colorize(:yellow)}")
            end

            def self.prepare(softwareInformation : Software::Information)
                runningProcess(Default::PrepareText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.configure(softwareInformation : Software::Information)
                runningProcess(Default::ConfigureText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.build(softwareInformation : Software::Information)
                runningProcess(Default::BuildText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.prepareInstallation(softwareInformation : Software::Information)
                runningProcess(Default::PrepareInstallationText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.stripFiles
                runningSubProcess(Default::StripFilesText)
            end

            def self.deploy
                runningSubProcess(Default::DeployText)
            end

            def self.updateSystemCache
                runningSubProcess(Default::UpdateSystemCacheText)
            end

            def self.install(softwareInformation : Software::Information)
                runningProcess(Default::InstallText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.updateKernelOptionsDatabase(softwareInformation : Software::Information)
                runningProcess(Default::UpdateKernelOptionsDatabaseText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.recordNeededKernelOptions
                kernelName = (selectedKernel.name == "" ? Default::FuturKernelText : selectedKernel.name )

                runningProcess(Default::RecordNeededKernelOptionsText+"#{kernelName.colorize(:green)}")
            end

            def self.clean(softwareInformation : Software::Information)
                runningProcess(Default::CleanText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.uninstall(softwareInformation : Software::Information)
                runningProcess(Default::UninstallText+"#{softwareInformation.name.colorize(:green)}")
            end

            def self.downloadError(link : String, error = nil)
                error(Default::ErrorDownloadText+link, error)
            end

            def self.runSystemCommandError(arguments : String, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, error = nil)

                argumentText = "#{Default::ErrorRunSystemCommandText1}#{arguments.squeeze(" ")}"
                pathText = String.new
                environmentText = String.new
                environmentFilePathText = String.new

                if !path.empty?
                    pathText = "#{Default::ErrorRunSystemCommandText2}#{(Ism.targetSystemInformation.handleChroot ? Ism.settings.rootPath : "")}#{path}".squeeze("/")
                end

                if !environment.empty?
                    environmentText = "#{Default::ErrorRunSystemCommandText3}#{(environment.map { |key| key.join("=") }).join(" ")}"
                end

                if !environmentFilePath.empty?
                    environmentFilePathText = "#{Default::ErrorRunSystemCommandText4}#{environmentFilePath}"
                end

                error( "#{argumentText}#{pathText}#{environmentText}#{environmentFilePathText}",
                                            error)
            end

        end

    end

end
