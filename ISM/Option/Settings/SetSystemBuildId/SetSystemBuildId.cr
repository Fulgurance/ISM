module ISM

    module Option

        class SettingsSetSystemBuildId < ISM::CommandLineOption

            module Default

                ShortText = "-ssbi"
                LongText = "setsystembuildid"
                Description = "Set the build id of the future installed system"
                SetText = "Setting the system build id to the value "

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
                    Ism.settings.setSystemBuildId(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
