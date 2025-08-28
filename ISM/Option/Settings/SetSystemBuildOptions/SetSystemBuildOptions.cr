module ISM

    module Option

        class SettingsSetSystemBuildOptions < ISM::CommandLineOption

            module Default

                ShortText = "-ssbo"
                LongText = "setsystembuildoptions"
                Description = "Set the default CPU flags for the compiler"
                SetText = "Setting system build options to the value "

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
                    Ism.settings.setSystemBuildOptions(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
