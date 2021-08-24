module ISM

    module Default

        module Option

            module Software

                ShortText = "-so"
                LongText = "software"
                Description = "Install, configure and remove softwares"
                Options = [ ISM::Option::SoftwareInstall.new ] of ISM::CommandLineOption
            end
            
        end

    end

end
