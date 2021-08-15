module ISM

    module Default

        module Option

            module System

                ShortText = "system"
                LongText = "system"
                Description = "Configure the system settings"
                Options = [ ISM::CommandLineOption.new( "setlcall",
                                                        "setlcall",
                                                        "Set the default value for LC_ALL variable",
                                                        Array(ISM::CommandLineOption).new)]

            end
        end

    end

end
