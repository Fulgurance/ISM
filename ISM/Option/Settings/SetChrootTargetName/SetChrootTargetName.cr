module ISM

    module Option

        class SettingsSetChrootTargetName < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsSetChrootTargetName::ShortText,
                        ISM::Default::Option::SettingsSetChrootTargetName::LongText,
                        ISM::Default::Option::SettingsSetChrootTargetName::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.settings.setChrootTargetName(ARGV[2+Ism.debugLevel])
                    Ism.printProcessNotification(ISM::Default::Option::SettingsSetChrootTargetName::SetText+ARGV[2+Ism.debugLevel])
                end
            end

        end
        
    end

end
