module ISM

    module Default

        class CommandLine

            Version = ISM::Version.new
            Options = Array(ISM::CommandLineOption).new
            Settings = ISM::CommandLineSettings.new
            SystemSettings = ISM::CommandLineSystemSettings.new
            Softwares = Array(ISM::AvailableSoftware).new
            Title = "Ingenius System Manager"
            ErrorUnknowArgument = "ISM error: unknow argument "
            ErrorUnknowArgumentHelp1 = "Use "
            ErrorUnknowArgumentHelp2 = "ism --help "
            ErrorUnknowArgumentHelp3 = "to know how to use ISM"
            DownloadText = "Downloading "
            CheckText = "Checking "
            ExtractText = "Extracting "
            PrepareText =  "Preparing " 
            ConfigureText = "Configuring "
            BuildText = "Building "
            InstallText = "Installing "
            UninstallText = "Uninstalling "

        end

    end

end
