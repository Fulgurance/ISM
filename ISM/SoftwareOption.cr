module ISM

    class SoftwareOption

        def_clone

        include JSON::Serializable

        property name : String
        property description : String
        property active : Bool
        setter dependencies : Array(ISM::SoftwareDependency)
        property kernelDependencies : Array(String)

        def initialize( @name = String.new,
                        @description = String.new,
                        @active = false,
                        @dependencies = Array(ISM::SoftwareDependency).new,
                        @kernelDependencies = Array(String).new)
        end

        def == (other : ISM::SoftwareOption) : Bool
            return @name == other.name && @active == other.active
        end

        def self.isPassName(optionName : String) : Bool
            return optionName.starts_with?(/Pass[0-9]/)
        end

        def isPass : Bool
            return self.class.isPassName(@name)
        end

        def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
            result = Array(ISM::SoftwareDependency).new

            @dependencies.each do |dependency|
                if allowDeepSearch || !Ism.softwareIsInstalled(dependency.information)
                    result.push(dependency)
                end
            end

            return result
        end

    end

end
