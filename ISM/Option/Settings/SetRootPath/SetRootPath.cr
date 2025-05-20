module ISM

    module Option

        class SettingsSetRootPath < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetRootPath::ShortText,
                        ISM::Default::Option::SettingsSetRootPath::LongText,
                        ISM::Default::Option::SettingsSetRootPath::Description)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    path = ARGV[2]

                    if path[-1] != '/'
                        path = path+"/"
                    end

                    Ism.settings.setRootPath(path)
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetRootPath::SetText+path)
                end
            end

        end
        
    end

end
