module ISM

    module Option

        class Settings

            class SetBuildOptions < CommandLine::Option

                module Default

                    ShortText = "-sbo"
                    LongText = "setbuildoptions"
                    Description = "Set the default CPU flags for the compiler"
                    SetText = "Setting build options to the value "

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        showHelp
                    else
                        Ism.settings.setBuildOptions(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
