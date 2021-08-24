module ISM

    module Default

        module Option

            module SoftwareInstall

                ShortText = "-i"
                LongText = "install"
                Description = "Install specific(s) software(s)"
                Options = Array(ISM::CommandLineOption).new

            end
            
        end

    end

end
