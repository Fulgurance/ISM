module ISM

    module Option

        class Debug < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Debug::ShortText,
                        ISM::Default::Option::Debug::LongText,
                        ISM::Default::Option::Debug::Description,
                        Array(ISM::CommandLineOption).new)
            end

        end
        
    end

end
