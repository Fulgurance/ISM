module ISM

    module Option

        class SystemSetLcAll < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SystemSetLcAll::ShortText,
                        ISM::Default::Option::SystemSetLcAll::LongText,
                        ISM::Default::Option::SystemSetLcAll::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    Ism.systemSettings.setLcAll(ARGV[2+Ism.debugLevel])
                    Ism.printProcessNotification(ISM::Default::Option::SystemSetLcAll::SetText+ARGV[2+Ism.debugLevel])
                end
            end

        end
        
    end

end
