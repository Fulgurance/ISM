module ISM

    module Default

        module Option

            module SettingsSetBuildOptions

                ShortText = "-sbo"
                LongText = "setbuildoptions"
                Description = "Set the default CPU flags for the compiler"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting buildOptions to the value "

            end
            
        end

    end

end
