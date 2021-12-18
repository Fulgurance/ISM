module ISM

    module Default

        module Option

            module SettingsSetSourcesPath

                ShortText = "-ssp"
                LongText = "setsourcespath"
                Description = "Set the default path where ISM will download softwares sources"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting sourcesPath to the value "

            end
            
        end

    end

end
