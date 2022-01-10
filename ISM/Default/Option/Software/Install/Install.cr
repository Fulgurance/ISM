module ISM

    module Default

        module Option

            module SoftwareInstall

                ShortText = "-i"
                LongText = "install"
                Description = "Install specific(s) software(s)"
                InextricableText = "ISM stopped due to an inextricable problem of dependencies with these softwares:"
                CalculationTitle = "ISM start to calculate depencies: "
                CalculationWaitingText = "Making dependencies tree"
                CalculationDoneText = "Done !"
                SummaryText = " new softwares will be install"
                InstallQuestion = "Would you like to install these softwares ?"
                YesReplyOption = "y"
                NoReplyOption = "n"
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                
            end
            
        end

    end

end
