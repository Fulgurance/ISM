module ISM

    module Default

        class CommandLine

            Options = Array(ISM::CommandLineOption).new
            Settings = ISM::CommandLineSettings.new
            Softwares = Array(ISM::Software).new
            Title = "Ingenius System Manager"
            ErrorUnknowArgument = "ISM error: unknow argument "
            ErrorUnknowArgumentHelp1 = "Use "
            ErrorUnknowArgumentHelp2 = "ism --help "
            ErrorUnknowArgumentHelp3 = "to know how to use ISM"

        end

    end

end
