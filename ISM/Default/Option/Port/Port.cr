module ISM

    module Default

        module Option

            module Port

                ShortText = "-p"
                LongText = "port"
                Description = "Manage #{ISM::Default::CommandLine::Name.upcase} ports"
                Options = [ ISM::Option::PortOpen.new,
                            ISM::Option::PortClose.new,
                            ISM::Option::PortSynchronize.new,
                            ISM::Option::PortSetTargetVersion.new,
                            ISM::Option::PortSearch.new]

            end
        end

    end

end
