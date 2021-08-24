module ISM

    module Default

        module Option

            module Settings

                ShortText = "-se"
                LongText = "settings"
                Description = "Configure ISM settings"
                Options = [ ISM::CommandLineOption.new( "setrootpath",
                                                        "setrootpath",
                                                        "Set the root path where ISM will work",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "setsourcespath",
                                                        "setsourcespath",
                                                        "Set the path where ISM will dowload softwares",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "settoolspath",
                                                        "settoolspath",
                                                        "Set the path where ISM will save the tools",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "setsystemname",
                                                        "setsystemname",
                                                        "Set the name of the system",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "settargetname",
                                                        "settargetname",
                                                        "Set the name of the target for the compiler",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "setarchitecture",
                                                        "setarchitecture",
                                                        "Set the default architecture for the compiler",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "setmakeoptions",
                                                        "setmakeoptions",
                                                        "Set the make options to compile with multiprocessing",
                                                        Array(ISM::CommandLineOption).new),
                            ISM::CommandLineOption.new( "setbuildoptions",
                                                        "setbuildoptions",
                                                        "Set the build options for the compiler",
                                                        Array(ISM::CommandLineOption).new)]

            end
        end

    end

end
