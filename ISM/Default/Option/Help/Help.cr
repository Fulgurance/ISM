module ISM

    module Default

        module Option

            module Help

                ShortText = "-h"
                LongText = "help"
                Description = "Display the help how to use ISM"
                Options = Array(ISM::CommandLineOption).new

            end
        end

    end

end
