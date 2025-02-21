module ISM

    module Option

        class SettingsSetDefaultMirror < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetDefaultMirror::ShortText,
                        ISM::Default::Option::SettingsSetDefaultMirror::LongText,
                        ISM::Default::Option::SettingsSetDefaultMirror::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    Ism.settings.setDefaultMirror(ARGV[2])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetDefaultMirror::SetText+ARGV[2])
                end
            end

        end
        
    end

end
