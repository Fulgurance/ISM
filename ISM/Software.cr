module ISM

    class Software

        property information = ISM::Default::Software::Information

        def initialize(information = ISM::Default::Software::Information)
            @information = information
        end

        def download

        end

        def install

        end

        def remove

        end

    end

end