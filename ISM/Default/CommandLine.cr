module ISM

    module Default

        module CommandLine

            DebugLevel = 0
            Title = "Ingenius System Manager"
            ErrorUnknowArgument = "ISM error: unknow argument "
            ErrorUnknowArgumentHelp1 = "Use "
            ErrorUnknowArgumentHelp2 = "ism --help "
            ErrorUnknowArgumentHelp3 = "to know how to use ISM"
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
            ErrorRunScriptText1 = "Failed to run the script "
            ErrorRunScriptText2 = " located at "
            ErrorConfigureText = "Failed to configure the source "
            ErrorMakeText = "Failed to run make in  "
            ErrorMoveFileText1 = "Failed to move "
            ErrorMoveFileText2 = " to "
            ErrorMakeDirectoryText = "Failed to make directory "
            ErrorDeleteDirectoryText = "Failed to delete directory "
            ErrorDeleteDirectoryRecursivelyText = "Failed to delete directory recursively "
            ErrorFileReplaceText1 = "Failed to replace the occurence "
            ErrorFileReplaceText2 = " to "
            ErrorFileReplaceText3 = " in the file "
            ErrorGetFileContentText = "Failed to get file content from "
            ErrorFileWriteDataText = "Failed to write data to "
            ErrorFileAppendDataText = "Failed to write data to "
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
