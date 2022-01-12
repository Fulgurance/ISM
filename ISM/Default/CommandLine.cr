module ISM

    module Default

        class CommandLine

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
            InstallText = "Installing "
            CleanText = "Cleaning "
            UninstallText = "Uninstalling "
            ErrorDownloadText = "Failed to download from "
            ErrorExtractText = "Failed to extract the archive "
            ErrorApplyPatchText = "Failed to apply the patch "
            ErrorConfigureText = "Failed to configure the source "
            ErrorMakeText = "Failed to run make in  "
            ErrorMoveFileText1 = "Failed to move "
            ErrorMoveFileText1 = " to "
            ErrorMakeDirectory = "Failed to make directory "
            Options = [ ISM::Option::Help.new,
                        ISM::Option::Version.new,
                        ISM::Option::Software.new,
                        ISM::Option::Port.new,
                        ISM::Option::System.new,
                        ISM::Option::Settings.new]

        end

    end

end
