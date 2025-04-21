module ISM

    module Default

        module Option

            module SystemComponent

                ShortText = "-c"
                LongText = "component"
                Description = "Manage and configure system component"
                Options = [ ISM::Option::ComponentList.new,
                            ISM::Option::ComponentActivate.new,
                            ISM::Option::ComponentDesactivate.new]
                
            end
            
        end

    end

end
