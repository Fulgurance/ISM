module ISM

    module Option

        class SettingsEnableInstallByChroot < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SettingsEnableInstallByChroot::ShortText,
                        ISM::Default::Option::SettingsEnableInstallByChroot::LongText,
                        ISM::Default::Option::SettingsEnableInstallByChroot::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    Ism.settings.setInstallByChroot(true)
                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::SettingsEnableInstallByChroot::SetText
                end
            end

        end
        
    end

end
