module ISM

    module Option

        class Settings

            class SetSystemMakeOptions < ISM::CommandLineOption

                module Default

                    ShortText = "-ssmo"
                    LongText = "setsystemmakeoptions"
                    Description = "Set the default parallel make jobs number for the compiler"
                    SetText = "Setting makeOptions to the value "

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
                        Ism.settings.setSystemMakeOptions(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
