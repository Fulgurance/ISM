module ISM

    module Default

        module Option

            module SoftwareUpdate

                ShortText = "-u"
                LongText = "update"
                Description = "Update specified software(s)"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end
