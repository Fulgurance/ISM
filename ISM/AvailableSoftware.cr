module ISM

    class AvailableSoftware

        property name = ISM::Default::AvailableSoftware::Name
        property versions = ISM::Default::AvailableSoftware::Versions

        def initialize( name = ISM::Default::AvailableSoftware::Name,
                        versions = ISM::Default::AvailableSoftware::Versions)

            @name = name
            @versions = versions
        end

    end

end