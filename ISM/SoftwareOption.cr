module ISM

    class SoftwareOption

        property name : String
        property description : String
        property active : Bool
        property dependencies : Array(ISM::SoftwareDependency)

        def initialize
            @name = String.new
            @description = String.new
            @active = false
            @dependencies = Array(ISM::SoftwareDependency).new
        end

        def == (other : ISM::SoftwareOption) : Bool
            return @name == other.name && @description == other.description && @active == other.active
        end

    end

end
