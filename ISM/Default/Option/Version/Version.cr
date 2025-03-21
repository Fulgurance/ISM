module ISM

    module Default

        module Option

            module Version

                ShortText = "-v"
                LongText = "version"
                Description = "Show and manage the #{ISM::Default::CommandLine::Name.upcase} version"
                Options = [ ISM::Option::VersionShow.new,
                            ISM::Option::VersionSwitch.new]

            end
        end

    end

end
