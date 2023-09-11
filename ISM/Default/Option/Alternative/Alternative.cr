module ISM

    module Default

        module Option

            module Alternative

                ShortText = "-a"
                LongText = "alternative"
                Description = "Set alternative choices for the system"
                Options = [ ISM::Option::Alternative.new ] of ISM::CommandLineOption

            end
        end

    end

end
