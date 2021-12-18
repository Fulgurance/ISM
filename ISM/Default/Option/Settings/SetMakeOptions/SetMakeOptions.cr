module ISM

    module Default

        module Option

            module SettingsSetMakeOptions

                ShortText = "-smo"
                LongText = "setmakeoptions"
                Description = "Set the default parallel make jobs number for the compiler"
                Options = Array(ISM::CommandLineOption).new
                SetText = "Setting makeOptions to the value "

            end
            
        end

    end

end
