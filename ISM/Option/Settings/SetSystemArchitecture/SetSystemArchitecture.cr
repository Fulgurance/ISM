module ISM

    module Option

        class SettingsSetSystemArchitecture < ISM::CommandLineOption

            module Default

                ShortText = "-ssa"
                LongText = "setsystemarchitecture"
                Description = "Set the default system architecture for the compiler"
                SetText = "Setting system architecture to the value "

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
                    Ism.settings.setSystemArchitecture(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
