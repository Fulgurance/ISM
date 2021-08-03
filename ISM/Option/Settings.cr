module ISM

    module Option

        class Settings < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Settings::ShortText,
                        ISM::Default::Option::Settings::LongText,
                        ISM::Default::Option::Settings::Description,
                        ISM::Default::Option::Settings::Options)
            end

            def start

            end

        end
        
    end

end
