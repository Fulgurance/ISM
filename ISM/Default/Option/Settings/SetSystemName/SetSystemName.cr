module ISM

    module Default

        module Option

            module SettingsSetSystemName

                ShortText = "-ssn"
                LongText = "setsystemname"
                Description = "Set the name of the future installed system"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting systemName to the value "

            end
            
        end

    end

end
