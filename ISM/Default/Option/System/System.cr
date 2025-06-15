module ISM

    module Default

        module Option

            module System

                ShortText = "-sy"
                LongText = "system"
                Description = "Manage the system"
                Options = [ ISM::Option::SystemComponent.new,
                            ISM::Option::SystemLock.new,
                            ISM::Option::SystemUnlock.new]

            end

        end

    end

end
