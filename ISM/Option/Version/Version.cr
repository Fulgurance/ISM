module ISM

    module Option

        class Version < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Version::ShortText,
                        ISM::Default::Option::Version::LongText,
                        ISM::Default::Option::Version::Description,
                        ISM::Default::Option::Version::Options)
            end

            def start

            end

        end
        
    end

end
