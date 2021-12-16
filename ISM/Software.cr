module ISM

    class Software

        property information = ISM::Default::Software::Information

        def initialize(information = ISM::Default::Software::Information)
            @information = information
        end

    end

end