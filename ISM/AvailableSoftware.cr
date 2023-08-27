module ISM

    class AvailableSoftware

        property name : String
        property versions : Array(ISM::SoftwareInformation)

        def initialize(@name, @versions)
        end

        def greatestVersion : ISM::SoftwareInformation
            return @versions.max_by {|entry| entry.version}
        end

    end

end
