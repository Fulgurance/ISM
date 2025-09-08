module ISM

    module Option

        class Settings

            class SetRootPath < CommandLine::Option

                module Default

                    ShortText = "-srp"
                    LongText = "setrootpath"
                    Description = "Set the default root path where to install softwares"
                    SetText = "Setting rootPath to the value "

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
                        path = ARGV[2]

                        if path[-1] != '/'
                            path = path+"/"
                        end

                        Ism.settings.setRootPath(path)
                        Ism.printProcessNotification(Default::SetText+path)
                    end
                end

            end

        end
        
    end

end
