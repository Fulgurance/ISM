module ISM

    module Default

        module Option

            module SoftwareRemove

                ShortText = "-r"
                LongText = "remove"
                Description = "Remove specific(s) software(s)"
                CalculationTitle = "ISM start to calculate depencies: "
                CalculationWaitingText = "Checking dependencies tree"
                CalculationDoneText = "Done !"
                SummaryText = " softwares will be uninstall"
                UninstallQuestion = "Would you like to uninstall these softwares ?"
                YesReplyOption = "y"
                NoReplyOption = "n"
                NotInstalledText = "All requested softwares are not installed. Task cancelled."
                NoInstalledMatchFound = "No match found with the database for "
                NoInstalledMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                RequestedSoftwaresAreDependencies = "Some requested softwares are dependencies for others installed softwares:"
                RequestedSoftwaresAreDependenciesAdvice = "If you really would like to remove them, remove them first."

            end
            
        end

    end

end
