module ISM

    module Default

        module Option

            module KeyringRemove

                ShortText = "-r"
                LongText = "remove"
                Description = "Remove specified public key from #{ISM::Default::CommandLine::Name.upcase}"
                RemoveText = "Removing public key from #{ISM::Default::CommandLine::Name.upcase} keyring."
                RemoveTextError1 = "Failed to remove the public key: "
                RemoveTextError2 = ". The file doesn't exist."

            end
            
        end

    end

end
