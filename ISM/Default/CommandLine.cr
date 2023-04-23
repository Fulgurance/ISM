module ISM

    module Default

        module CommandLine

            DebugLevel = 0
            Title = "Ingenius System Manager"
            Name = "ism"
            ErrorUnknowArgument = "ISM error: unknow argument "
            ErrorUnknowArgumentHelp1 = "Use "
            ErrorUnknowArgumentHelp2 = "ism --help "
            ErrorUnknowArgumentHelp3 = "to know how to use ISM"
            ProcessNotificationCharacters = ">_"
            DownloadText = "Downloading "
            CheckText = "Checking "
            ExtractText = "Extracting "
            PatchText = "Patching "
            PrepareText =  "Preparing " 
            ConfigureText = "Configuring "
            BuildText = "Building "
            PrepareInstallationText = "Preparing installation for "
            InstallText = "Installing "
            CleanText = "Cleaning "
            UninstallText = "Uninstalling "
            ErrorDownloadText = "Failed to download from "
            ErrorCheckText1 = "Failed check because the md5sum digest of "
            ErrorCheckText2 = " doesn't match with the given md5sum value "
            ErrorExtractText = "Failed to extract the archive "
            ErrorApplyPatchText = "Failed to apply the patch "
            ErrorMakeSymbolicLinkText1 = "Failed to make symbolic link from "
            ErrorMakeSymbolicLinkText2 = " to "
            ErrorCopyFileText1 = "Failed to copy the file from "
            ErrorCopyFileText2 = " to "
            ErrorCopyDirectoryText1 = "Failed to copy the directory from "
            ErrorCopyDirectoryText2 = " to "
            ErrorDeleteFileText = "Failed to delete the file "
            ErrorDeleteAllHiddenFilesText = "Failed to delete hidden files in "
            ErrorDeleteAllHiddenFilesRecursivelyText = "Failed to delete hidden files recursively in "
            ErrorRunSystemCommandText1 = "Failed to run "
            ErrorRunSystemCommandText2 = " in "
            ErrorRunSystemCommandText3 = " with given environment "
            ErrorGenerateEmptyFileText = "Failed to generate the empty file "
            ErrorMoveFileText1 = "Failed to move "
            ErrorMoveFileText2 = " to "
            ErrorMakeDirectoryText = "Failed to make directory "
            ErrorReplaceTextAllFilesNamedText1 = "Failed to replace the line containing "
            ErrorReplaceTextAllFilesNamedText2 = " to the content "
            ErrorReplaceTextAllFilesNamedText3 = " in all files named "
            ErrorReplaceTextAllFilesNamedText4 = " in the directory "
            ErrorReplaceTextAllFilesRecursivelyNamedText1 = "Failed to replace the line containing "
            ErrorReplaceTextAllFilesRecursivelyNamedText2 = " to the content "
            ErrorReplaceTextAllFilesRecursivelyNamedText3 = " in all files named "
            ErrorReplaceTextAllFilesRecursivelyNamedText4 = " in the directory "
            ErrorDeleteAllFilesFinishingText1 = "Failed to delete all files name's finishing by "
            ErrorDeleteAllFilesFinishingText2 = " located at "
            ErrorDeleteAllFilesRecursivelyFinishingText1 = "Failed to delete recursively all files name's finishing by "
            ErrorDeleteAllFilesRecursivelyFinishingText2 = " located at "
            ErrorDeleteDirectoryText = "Failed to delete directory "
            ErrorDeleteDirectoryRecursivelyText = "Failed to delete directory recursively "
            ErrorSetPermissionsText1 = "Failed to set the permissions "
            ErrorSetPermissionsText2 = " to the file "
            ErrorSetPermissionsRecursivelyText1 = "Failed to set the permissions recursively"
            ErrorSetPermissionsRecursivelyText2 = " at the path "
            ErrorSetOwnerText1 = "Failed to set the owner uid:"
            ErrorSetOwnerText2 = " and gid:"
            ErrorSetOwnerText3 = " to the file "
            ErrorSetOwnerRecursivelyText1 = "Failed to set the owner uid:"
            ErrorSetOwnerRecursivelyText2 = " and gid:"
            ErrorSetOwnerRecursivelyText3 = " at the path "
            ErrorFileReplaceTextText1 = "Failed to replace the occurence "
            ErrorFileReplaceTextText2 = " to "
            ErrorFileReplaceTextText3 = " in the file "
            ErrorFileReplaceLineContainingText1 = "Failed to replace the line containing "
            ErrorFileReplaceLineContainingText2 = " to the content "
            ErrorFileReplaceLineContainingText3 = " in the file "
            ErrorReplaceTextAtLineNumberText1 = "Failed to replace the text "
            ErrorReplaceTextAtLineNumberText2 = " to the content "
            ErrorReplaceTextAtLineNumberText3 = " in the file "
            ErrorReplaceTextAtLineNumberText4 = " at the line number "
            ErrorFileDeleteLineText1 = "Failed to delete the line number "
            ErrorFileDeleteLineText2 = " in the file "
            ErrorGetFileContentText = "Failed to get file content from "
            ErrorFileWriteDataText = "Failed to write data to "
            ErrorFileAppendDataText = "Failed to write data to "
            ErrorFileUpdateContentText = "Failed to update file content in "
            Options = [ ISM::Option::Help.new,
                        ISM::Option::Version.new,
                        ISM::Option::Software.new,
                        ISM::Option::Port.new,
                        ISM::Option::System.new,
                        ISM::Option::Settings.new,
                        ISM::Option::Debug.new]

        end

    end

end
