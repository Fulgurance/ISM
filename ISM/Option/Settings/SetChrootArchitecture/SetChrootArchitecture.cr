module ISM

    module Option

        class SettingsSetChrootArchitecture < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootArchitecture::ShortText,
                        ISM::Default::Option::SettingsSetChrootArchitecture::LongText,
                        ISM::Default::Option::SettingsSetChrootArchitecture::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setChrootArchitecture(ARGV[2+Ism.debugLevel])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootArchitecture::SetText+ARGV[2+Ism.debugLevel])
                end
            end

        end
        
    end

end
