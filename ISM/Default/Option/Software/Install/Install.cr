module ISM

    module Default

        module Option

            module SoftwareInstall

                ShortText = "-i"
                LongText = "install"
                Description = "Install specific(s) software(s)"
                Options = Array(ISM::CommandLineOption).new
                InstallQuestion = "Would you like to install this software ?"
                YesReplyOption = "y"
                NoReplyOption = "n"

            end
            
        end

    end

end
