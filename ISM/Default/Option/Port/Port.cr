module ISM

    module Default

        module Option

            module Port

                ShortText = "-p"
                LongText = "port"
                Description = "Manage ISM ports"
                Options = [ ISM::Option::PortOpen.new,
                            ISM::Option::PortClose.new]

            end
        end

    end

end
