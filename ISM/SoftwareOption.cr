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

        def self.isPassName(optionName : String) : Bool
            return optionName.starts_with?(/Pass[0-9]/)

            rescue exception
                ISM::Error.show(className: self.class.name,
                                functionName: "isPassName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def isPass : Bool
            return self.class.isPassName(@name)

            rescue exception
                ISM::Error.show(className: self.class.name,
                                functionName: "isPass",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
            result = Array(ISM::SoftwareDependency).new

            @dependencies.each do |dependency|
                if allowDeepSearch || !Ism.softwareIsInstalled(dependency.information)
                    result.push(dependency)
                end
            end

            return result

            rescue exception
                ISM::Error.show(className: self.class.name,
                                functionName: "dependencies",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
