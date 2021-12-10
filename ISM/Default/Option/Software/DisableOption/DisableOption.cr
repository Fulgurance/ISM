module ISM

    module Default

        module Option

            module SoftwareDisableOption

                ShortText = "-do"
                LongText = "disableoption"
                Description = "Disable a specific software option"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end
