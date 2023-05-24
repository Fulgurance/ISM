module ISM

    class SoftwareOption

        def_clone

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
            return @name == other.name && @active == other.active
        end

        def isPass : Bool
            return @name.starts_with?(/Pass[0-9]/)
        end

    end

end
