module ISM

    module Default

        module Option

            module SoftwareRemove

                ShortText = "-r"
                LongText = "remove"
                Description = "Remove specific(s) software(s)"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end