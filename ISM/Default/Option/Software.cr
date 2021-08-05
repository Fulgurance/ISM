module ISM

    module Default

        module Option

            module Software

                ShortText = "software"
                LongText = "software"
                Description = "Install, configure and remove softwares"
                Options = [ ISM::CommandLineOption.new( "-i",
                                                        "install",
                                                        "Install specified software(s)",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "-r",
                                                        "remove",
                                                        "Remove specified software(s)",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "-u",
                                                        "update",
                                                        "Update specified software(s)",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "-s",
                                                        "synchronize",
                                                        "Synchronize the ISM softwares database",
                                                        Array(ISM::CommandLineOption).new)]

            end
            
        end

    end

end
