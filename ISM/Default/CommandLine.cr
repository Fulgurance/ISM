module ISM

    module Default

        module CommandLine

            Title = "Ingenius System Manager"
            Name = "ism"
            SystemId = "250"
            NeedToBeRunAsNormalUserText = "#{Name.upcase} can't be run as superuser. You must be a standard user and in the system group ism"
            NeedToBeRunAsMemberOfIsmGroupText = "#{Name.upcase} can't be run if you are not member of the system group ism"
            ErrorUnknowArgument = "#{Name.upcase} error: unknow argument "
            ErrorUnknowArgumentHelp1 = "Use "
            ErrorUnknowArgumentHelp2 = "ism --help "
            ErrorUnknowArgumentHelp3 = "to know how to use #{Name.upcase}"
            ProcessNotificationCharacters = "■"
            InternalErrorTitle = "Internal error"
            TaskBuildingProcessErrorText1 = "The #{Name.upcase} task at "
            TaskBuildingProcessErrorText2 = " encountered an error at line number "
            InstallerImplementationErrorTitle = "Software installer implementation error"
            InstallerImplementationErrorText1 = "The installer for the software "
            InstallerImplementationErrorText2 = " encountered an error at line number "
            InstallerImplementationErrorNotificationHelp = "#{Name.upcase} raised that error because the task cannot be compiled. That mean the related installer need to be fix."
            TaskBuildingErrorNotificationHelp = "#{Name.upcase} raised that error because the task cannot be compiled. That mean probably the task building process need to be fix."
            SystemCallErrorNotificationHelp = "#{Name.upcase} raised that error because the ran script did not call properly a system command or the system command itself need to be fix."
            TaskCompilationText = "Task compilation in process: "
            CompilationWaitingText = "Compiling the requested task"
            TaskCompilationFailedText = "Failed !"
            SecurityNotificationTitleText = "(SECURITY: superuser access required or expired)"
            SecurityNotificationReasonText = "Reason:"
            SecurityNotificationDetailsText = "Details:"
            ChrootSecurityNotificationReasonText = "ISM will perform a chroot."
            ChrootSecurityNotificationDetailsText = "All tasks under the chroot will be performed as normal user. However, the chroot command require to be run as root."
            PrepareChrootDevConsoleSecurityNotificationReasonText = "ISM will create the /dev/console node to prepare the chroot."
            PrepareChrootDevConsoleSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareChrootDevNullSecurityNotificationReasonText = "ISM will create the /dev/null node to prepare the chroot."
            PrepareChrootDevNullSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareChrootDevSecurityNotificationReasonText = "ISM will create the /dev node to prepare the chroot."
            PrepareChrootDevSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareChrootDevPtsSecurityNotificationReasonText = "ISM will create the /dev/pts node to prepare the chroot."
            PrepareChrootDevPtsSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareChrootProcSecurityNotificationReasonText = "ISM will create the /proc node to prepare the chroot."
            PrepareChrootProcSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareChrootSysSecurityNotificationReasonText = "ISM will create the /sys node to prepare the chroot."
            PrepareChrootSysSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareChrootNetworkConfigurationSecurityNotificationReasonText = "ISM will copy the network settings at /etc/resolv.conf from the host under the chroot."
            PrepareChrootNetworkConfigurationSecurityNotificationDetailsText = "This task can only be performed as root. It will prepare the new system for a chroot."
            PrepareRootPermissionsSecurityNotificationReasonText = "ISM will set proper rights for the new system"
            PrepareRootPermissionsSecurityNotificationDetailsText = "This task can only be performed as root. It will change the default owner as root for the new system."
            StripInstalledFilesSecurityNotificationReasonText = "ISM will strip all installed files."
            StripInstalledFilesSecurityNotificationDetailsText = "To strip the installed files, it is needed root access. I will remove all debug symbols."
            InstallFileSecurityNotificationReasonText = "ISM will install a file to the system."
            InstallFileSecurityNotificationDetailsText = "To perform this task, a root access is required"
            InstallSymlinkSecurityNotificationReasonText = "ISM will install a symlink to the system."
            InstallSymlinkSecurityNotificationDetailsText = "To perform this task, a root access is required."
            InstallDirectorySecurityNotificationReasonText = "ISM will install a directory to the system."
            InstallDirectorySecurityNotificationDetailsText = "To perform this task, a root access is required."
            UninstallFileSecurityNotificationReasonText = "ISM will uninstall a file from the system."
            UninstallFileSecurityNotificationDetailsText = "To perform this task, a root access is required."
            UninstallDirectorySecurityNotificationReasonText = "ISM will uninstall a directory from the system."
            UninstallDirectorySecurityNotificationDetailsText = "To perform this task, a root access is required."
            GenerateEmptyPasswdFileSecurityNotificationReasonText = "ISM will generate an empty /usr/bin/passwd file."
            GenerateEmptyPasswdFileSecurityNotificationDetailsText = "At the first installation of shadow, the passwd binary must be present. Root access is required to create it."
            RunLocaledefCommandSecurityNotificationReasonText = "ISM need to compile a charmap."
            RunLocaledefCommandSecurityNotificationDetailsText = "This task can only be performed as root. It will install a locale as a binary form."
            RunDircolorsCommandSecurityNotificationReasonText = "ISM need to generate a default /etc/dircolors."
            RunDircolorsCommandSecurityNotificationDetailsText = "This task can only be performed as root. It will generate a default configuration for dircolors."
            RunLdconfigCommandSecurityNotificationReasonText = "ISM need to update the cache for the libraries."
            RunLdconfigCommandSecurityNotificationDetailsText = "This task can only be performed as root. It will run the command ldconfig to update the cache."
            RunPwconvCommandSecurityNotificationReasonText = "ISM need to generate the /etc/shadow file."
            RunPwconvCommandSecurityNotificationDetailsText = "This task can only be performed as root. It will run the command pwconv to generate it."
            RunGrpconvCommandSecurityNotificationReasonText = "ISM need to generate the /etc/gshadow file."
            RunGrpconvCommandSecurityNotificationDetailsText = "This task can only be performed as root. It will run the command grpconv to generate it."
            RunZicCommandSecurityNotificationReasonText = "ISM need to compile a timezone"
            RunZicCommandSecurityNotificationDetailsText = "To perform this task, a root access is required. It will generate a time conversion information file."
            LockSystemAccessSecurityNotificationReasonText = "ISM need to temporary unlock the access to system critical points"
            LockSystemAccessSecurityNotificationDetailsText = "This task can only be performed as root. It unlock temporary the access of /lib,/bin,/sbin and /libexec"
            UnlockSystemAccessSecurityNotificationReasonText = "ISM need to lock the access to system critical points"
            UnlockSystemAccessSecurityNotificationDetailsText = "This task can only be performed as root. It will lock the access of /lib,/bin,/sbin and /libexec."
            DownloadText = "Downloading "
            CheckText = "Checking "
            ExtractText = "Extracting "
            PatchText = "Patching "
            LocalPatchText = "Applying local patch added by the user "
            PrepareText =  "Preparing " 
            ConfigureText = "Configuring "
            BuildText = "Building "
            PrepareInstallationText = "Preparing installation for "
            InstallText = "Installing "
            DeployText = "Deploying "
            RecordNeededKernelOptionsText = "Recording needed kernel options for "
            CleanText = "Cleaning "
            FuturKernelText = "future kernel (not installed yet)"
            UpdateKernelOptionsDatabaseText = "Updating kernel options database for "
            UninstallText = "Uninstalling "
            ErrorDownloadText = "Failed to download from "
            ErrorConnexionText1 = "Failed to connect to "
            ErrorConnexionText2 = ". The connexion is unaivalable"
            ErrorCheckText1 = "Failed check because the sha512 digest of "
            ErrorCheckText2 = " doesn't match with the given sha512 value "
            ErrorExtractText1 = "Failed to extract the archive located at "
            ErrorExtractText2 = " to "
            ErrorApplyPatchText = "Failed to apply the patch "
            ErrorUpdateUserFileText = "Failed to update the user file with the data: "
            ErrorUpdateGroupFileText = "Failed to update the group file with the data: "
            ErrorCopyFileText1 = "Failed to copy the file from "
            ErrorCopyFileText2 = " to "
            ErrorCopyDirectoryText1 = "Failed to copy the directory from "
            ErrorCopyDirectoryText2 = " to "
            ErrorDeleteFileText = "Failed to delete the file "
            ErrorMoveFileText1 = "Failed to move "
            ErrorMoveFileText2 = " to "
            ErrorMakeDirectoryText = "Failed to make directory "
            ErrorDeleteDirectoryText = "Failed to delete directory "
            ErrorMakeLinkUnknowTypeText1 = "Failed to make symbolic link from "
            ErrorMakeLinkUnknowTypeText2 = " to "
            ErrorMakeLinkUnknowTypeText3 = ". Unknow link type: "
            ErrorGetFileContentText = "Failed to get file content from "
            ErrorRunSystemCommandText1 = "Failed to run "
            ErrorRunSystemCommandText2 = " in "
            ErrorRunSystemCommandText3 = " with given environment "
            ErrorRunSystemCommandText4 = " with the loaded environment file "
            ErrorRunSystemCommandUnknownError = "#{Name.upcase} encountered an error with the last executed command, but was not able to record it. The reason is unknown."
            ErrorUpdateKernelOptionsDatabaseText = "Failed to update the option database for the kernel "
            AmbiguousSearchTitle = "The searched software name is ambiguous."
            AmbiguousSearchText = "#{Name.upcase} is unable to find the requested software because there are multiple entry in the database for this name:"
            InextricableText = "#{Name.upcase} stopped due to an inextricable problem of dependencies with these softwares:"
            MissingSelectedDependenciesText = "#{Name.upcase} stopped due to missing unique dependencies not selected yet:"
            MissingSelectionText = "One of these unique dependencies need to be selected:"
            SkippedUpdatesText = "#{Name.upcase} will skip some updates due to missing dependencies:"
            UnavailableText1 = "#{Name.upcase} stopped due to some missing dependencies for the requested softwares:"
            UnavailableText2 = " is missing for "
            NoUpdate = "System up to date."
            NoCleaningRequiredMessage = "No cleaning required. Task complete."
            CalculationTitle = "#{Name.upcase} start to calculate dependencies: "
            CalculationWaitingText = "Checking dependency tree"
            SynchronizationWaitingText = "Synchronization with the online database"
            CodependencyExtensionText = "Codependency"
            CalculationDoneText = "Done !"
            Separator = "============"
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

            Options = [ ISM::Option::Help.new,
                        ISM::Option::Version.new,
                        ISM::Option::Software.new,
                        ISM::Option::System.new,
                        ISM::Option::Port.new,
                        ISM::Option::Settings.new]

        end

    end

end
