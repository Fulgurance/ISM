module ISM

    module Option

        class SettingsSetChrootCpeName < ISM::CommandLineOption

            module Default

                ShortText = "-sccpen"
                LongText = "setchrootcpename"
                Description = "Set the CPE name of the future chroot installed system"
                SetText = "Setting chroot system cpe name to the value "

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
                    Ism.settings.setChrootCpeName(ARGV[2])
                    Ism.printProcessNotification(Default::SetText+ARGV[2])
                end
            end

        end
        
    end

end
