module ISM

    module Default

        module Option

            module System

                ShortText = "-sy"
                LongText = "system"
                Description = "Manage the system"
                Options = [ISM::Option::SystemComponent.new] of ISM::CommandLineOption

            end

        end

    end

end
