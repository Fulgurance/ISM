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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def isPass : Bool
            return @name.starts_with?(/Pass[0-9]/)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
            result = Array(ISM::SoftwareDependency).new

            @dependencies.each do |dependency|
                if allowDeepSearch || !Ism.softwareIsInstalled(dependency.information)
                    result.push(dependency)
                end
            end

            return result

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
