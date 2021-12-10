module ISM

    module Default

        module Option

            module SoftwareSynchronize

                ShortText = "-sy"
                LongText = "synchronize"
                Description = "Synchronize the software database"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end
