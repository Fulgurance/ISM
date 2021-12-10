module ISM

    module Default

        module Option

            module SoftwareEnableOption

                ShortText = "-eo"
                LongText = "enableoption"
                Description = "Enable a specific software option"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end
