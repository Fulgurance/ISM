module ISM

    module Option

        class Settings

            class SetDefaultMirror < ISM::CommandLineOption

                module Default

                    ShortText = "-sdm"
                    LongText = "setdefaultmirror"
                    Description = "Set the default mirror for ISM"
                    SetText = "Setting the default mirror to "

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
                        Ism.settings.setDefaultMirror(ARGV[2])
                        Ism.printProcessNotification(Default::SetText+ARGV[2])
                    end
                end

            end

        end
        
    end

end
