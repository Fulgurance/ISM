module ISM

    module Default

        module Option

            module Software

                ShortText = "-so"
                LongText = "software"
                Description = "Install, configure and remove softwares"
                Options = [ ISM::Option::SoftwareDisableOption.new,
                            ISM::Option::SoftwareEnableOption.new,
                            ISM::Option::SoftwareInstall.new,
                            ISM::Option::SoftwareUninstall.new,
                            ISM::Option::SoftwareClean.new,
                            ISM::Option::SoftwareSearch.new,
                            ISM::Option::SoftwareSynchronize.new,
                            ISM::Option::SoftwareUpdate.new]
                
            end
            
        end

    end

end
