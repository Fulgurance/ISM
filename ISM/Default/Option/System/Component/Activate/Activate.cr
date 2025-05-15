module ISM

    module Default

        module Option

            module ComponentActivate

                ShortText = "-a"
                LongText = "activate"
                Description = "Activate a specific system component\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism system component [componentname] activate [optionname]"
                ShowHelpDescription = "Activate a specific system component"
                ShowHelpExampleText1 = "Need to be use like this:"
                ShowHelpExampleText2 = "ism system component [componentname] activate [optionname]"
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                SetText1 = "Enabling the option "
                SetText2 = " for the component "
                OptionNoMatchFound1 = "No matching option named "
                OptionNoMatchFound2 = " found for the component "

            end
            
        end

    end

end
