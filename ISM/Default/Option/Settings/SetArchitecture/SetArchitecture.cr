module ISM

    module Default

        module Option

            module SettingsSetArchitecture

                ShortText = "-sa"
                LongText = "setarchitecture"
                Description = "Set the default target architecture for the compiler"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting architecture to the value "

            end
            
        end

    end

end
