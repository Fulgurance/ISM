module ISM

    class SoftwareOption

        def_clone

        property name : String
        property description : String
        property active : Bool
        property dependencies : Array(ISM::SoftwareDependency)
        property kernelDependencies : Array(String)

        def initialize
            @name = String.new
            @description = String.new
            @active = false
            @dependencies = Array(ISM::SoftwareDependency).new
            @kernelDependencies = Array(String).new
        end

        def == (other : ISM::SoftwareOption) : Bool
            return @name == other.name && @active == other.active
        end

        def isPass : Bool
            return @name.starts_with?(/Pass[0-9]/)
        end

    end

end
