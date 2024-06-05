module ISM

    module Default

        module Option

            module SoftwareSelectDependency

                ShortText = "-sd"
                LongText = "selectdependency"
                Description = "Select a dependency part of unique set\n\t\t\t\tNeed to be use like this:\n\t\t\t\tism software [softwarename] selectdependency [dependencyname]"
                ShowHelpDescription = "Enable a specific software dependency"
                ShowHelpExampleText1 = "Need to be use like this:"
                ShowHelpExampleText2 = "ism software [softwarename] selectdependency [dependencyname]"
                NoMatchFound = "No match found with the database for "
                NoMatchFoundAdvice = "Maybe it's needed of refresh the database?"
                SetText1 = "Enabling the dependency "
                SetText2 = " for the software "
                DependencyNoMatchFound1 = "No matching dependency named "
                DependencyNoMatchFound2 = " found for the software "

            end
            
        end

    end

end
