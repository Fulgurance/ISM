module ISM

    module Default

        module Option

            module SoftwareSearch

                ShortText = "-se"
                LongText = "search"
                Description = "Search specific(s) software(s)"
                Options = Array(ISM::CommandLineOption).new
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                NameField = "Name: "
                DescriptionField = "Description: "
                AvailablesArchitecturesField = "Available(s) architecture(s): "
                WebsiteField = "Website: "
                AvailablesVersionsField = "Available(s) Version(s): "
                InstalledVersionField = "Installed Version: "
                OptionsField = "Options: "
            end
            
        end

    end

end
