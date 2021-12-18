module ISM

    module Default

        module Option

            module SettingsSetRootPath

                ShortText = "-srp"
                LongText = "setrootpath"
                Description = "Set the default root path where to install softwares"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting rootPath to the value "

            end
            
        end

    end

end
