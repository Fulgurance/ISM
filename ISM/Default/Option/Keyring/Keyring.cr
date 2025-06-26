module ISM

    module Default

        module Option

            module Keyring

                ShortText = "-k"
                LongText = "keyring"
                Description = "Manage #{ISM::Default::CommandLine::Name.upcase} public keys, required to check software signatures"
                Options = [ ISM::Option::KeyringAdd.new,
                            ISM::Option::KeyringRemove.new,
                            ISM::Option::KeyringSearch.new]

            end
        end

    end

end
