module ISM

    class Software

        class Option

            def_clone

            include JSON::Serializable

            property name : String
            property description : String
            property active : Bool
            setter dependencies : Array(Software::Dependency)
            property kernelDependencies : Array(String)

            def initialize( @name = String.new,
                            @description = String.new,
                            @active = false,
                            @dependencies = Array(Software::Dependency).new,
                            @kernelDependencies = Array(String).new)
            end

            def == (other : Software::Option) : Bool
                return @name == other.name && @active == other.active
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

            def dependencies(allowDeepSearch = false) : Array(Software::Dependency)
                result = Array(Software::Dependency).new

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

end
