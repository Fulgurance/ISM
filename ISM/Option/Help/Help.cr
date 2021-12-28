module ISM

    module Option

        class Help < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Help::ShortText,
                        ISM::Default::Option::Help::LongText,
                        ISM::Default::Option::Help::Description,
                        Array(ISM::CommandLineOption).new)
            end

        end
        
    end

end
