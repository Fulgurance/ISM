module ISM

    class AvailableSoftware

        property name : String
        property versions : Array(ISM::SoftwareInformation)

        def initialize(@name, @versions)
        end

    end

end