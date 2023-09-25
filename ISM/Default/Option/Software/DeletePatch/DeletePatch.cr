module ISM

    module Default

        module Option

            module SoftwareDeletePatch

                ShortText = "-rp"
                LongText = "deletepatch"
                Description = "Delete a local patch for a specific software\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism software [softwarename-softwareversion] deletepatch [patchpath]"
                ShowHelpDescription = "Delete a local patch for a specific software"
                ShowHelpExampleText1 = "Need to be use like this:"
                ShowHelpExampleText2 = "ism software [softwarename-softwareversion] deletepatch [patchpath]"
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                Text1 = "Deleting patch "
                Text2 = " for the software "
                NoFileFound1 = "The patch "
                NoFileFound2 = " doesn't exist for the software "

            end
            
        end

    end

end
