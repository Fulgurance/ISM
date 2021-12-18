module ISM

    module Default

        module Option

            module SystemSetLcAll

                ShortText = "-sla"
                LongText = "setlcall"
                Description = "Set the LC_ALL variable to setup the localization of specific country"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting LcAll to the value "

            end
            
        end

    end

end
