module ISM

    module Default

        module Option

            module Version

                ShortText = "-v"
                LongText = "--version"
                Description = "Display the ISM version"
                Options = Array(ISM::CommandLineOption).new

            end
        end

    end

end
