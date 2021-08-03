module ISM

    module Option

        class Software < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Software::ShortText,
                        ISM::Default::Option::Software::LongText,
                        ISM::Default::Option::Software::Description,
                        ISM::Default::Option::Software::Options)
            end

            def start

            end

        end
        
    end

end
