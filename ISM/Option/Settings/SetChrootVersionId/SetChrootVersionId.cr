module ISM

    module Option

        class SettingsSetChrootVersionId < ISM::CommandLineOption

            module Default

                ShortText = "-scvi"
                LongText = "setchrootversionid"
                Description = "Set the version ID of the future chroot installed system"
                SetText = "Setting chroot system version ID to the value "

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
                    Ism.settings.setChrootVersionId(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
