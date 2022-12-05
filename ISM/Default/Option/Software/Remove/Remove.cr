module ISM

    module Default

        module Option

            module SoftwareRemove

                ShortText = "-r"
                LongText = "remove"
                Description = "Remove specific(s) software(s)"
                SummaryText = " softwares will be uninstall"
                UninstallQuestion = "Would you like to uninstall these softwares ?"
                YesReplyOption = "y"
                NoReplyOption = "n"
                NotInstalledText = "All requested softwares are not installed. Task cancelled."
                NoInstalledMatchFound = "No match found with the database for "
                NoInstalledMatchFoundAdvice = "Maybe it's needed of refresh the database?"

            end
            
        end

    end

end
