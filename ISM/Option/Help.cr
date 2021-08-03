module ISM

    module Option
        Help = ISM::CommandLineOption.new(  ISM::Default::Option::Help::ShortText,
                                            ISM::Default::Option::Help::LongText,
                                            ISM::Default::Option::Help::Description,
                                            ISM::Default::Option::Help::Options)
    end

end
