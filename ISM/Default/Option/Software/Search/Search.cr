module ISM

    module Default

        module Option

            module SoftwareSearch

                ShortText = "-se"
                LongText = "search"
                Description = "Search specific(s) software(s)"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end
