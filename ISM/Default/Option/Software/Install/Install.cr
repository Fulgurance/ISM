module ISM

    module Default

        module Option

            module SoftwareInstall

                ShortText = "-i"
                LongText = "install"
                Description = "Install specific(s) software(s)"
                InextricableText = "ISM stopped due to an inextricable problem of dependencies with these softwares:"
                UnavailableText = "ISM stopped due to some missing dependencies for the requested softwares:"
                CalculationTitle = "ISM start to calculate dependencies: "
                CalculationWaitingText = "Checking dependencies tree"
                CalculationDoneText = "Done !"
                SummaryText = " new softwares will be install"
                InstallQuestion = "Would you like to install these softwares ?"
                YesReplyOption = "y"
                NoReplyOption = "n"
                InstallingText = "Installing"
                DoesntExistText = "Some requested softwares doesn't exist. Task cancelled."
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                NoVersionAvailable = "Some requested versions are not available: "
                NoVersionAvailableAdvice = "Maybe it's needed of refresh the database?"
                InstalledText = "is installed"
                
            end
            
        end

    end

end
