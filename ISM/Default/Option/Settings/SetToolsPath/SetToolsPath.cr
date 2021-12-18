module ISM

    module Default

        module Option

            module SettingsSetToolsPath

                ShortText = "-stp"
                LongText = "settoolspath"
                Description = "Set the default path where ISM will install the tools"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting toolsPath to the value "

            end
            
        end

    end

end
