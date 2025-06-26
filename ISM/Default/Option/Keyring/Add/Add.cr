module ISM

    module Default

        module Option

            module KeyringAdd

                ShortText = "-a"
                LongText = "add"
                Description = "Add specified public key to #{ISM::Default::CommandLine::Name.upcase}"
                AddText = "Adding public key to #{ISM::Default::CommandLine::Name.upcase} keyring."
                AddTextError1 = "Failed to add the public key: "
                AddTextError2 = ". The file doesn't exist."

            end
            
        end

    end

end
