module ISM

    module Option

        class SettingsSetSystemTargetName < ISM::CommandLineOption

            module Default

                ShortText = "-sstn"
                LongText = "setsystemtargetname"
                Description = "Set the default machine target for the compiler"
                SetText = "Setting system target name to the value "

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
                    Ism.settings.setSystemTargetName(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
