module ISM

    module Default

        module Option

            module SettingsSetTargetName

                ShortText = "-stn"
                LongText = "settargetname"
                Description = "Set the default machine target for the compiler"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting targetName to the value "

            end
            
        end

    end

end
