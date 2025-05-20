module ISM

    module Option

        class SettingsSetSystemTargetName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetSystemTargetName::ShortText,
                        ISM::Default::Option::SettingsSetSystemTargetName::LongText,
                        ISM::Default::Option::SettingsSetSystemTargetName::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setSystemTargetName(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemTargetName::SetText+ARGV[2])
                end
            end

        end
        
    end

end
