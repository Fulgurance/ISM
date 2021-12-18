module ISM

    module Default

        module Option

            module System

                ShortText = "-sy"
                LongText = "system"
                Description = "Configure the system settings"
                Options = [ ISM::Option::SystemSetLcAll.new ] of ISM::CommandLineOption

            end
        end

    end

end
