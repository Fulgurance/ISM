module ISM

    module Option

        class Settings

            class SetMakeOptions < CommandLine::Option

                module Default

                    ShortText = "-smo"
                    LongText = "setmakeoptions"
                    Description = "Set the default parallel make jobs number for the compiler"
                    SetText = "Setting make options to the value "

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
                        Ism.settings.setMakeOptions(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
