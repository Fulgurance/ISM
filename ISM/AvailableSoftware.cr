module ISM

    class AvailableSoftware

        property port : String
        property name : String
        property versions : Array(Software::Information)

        def initialize(@port = String.new, @name = String.new, @versions = Array(Software::Information).new)
        end

        def fullName : String
            return "@#{@port}:#{@name}"

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "fullName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        private def includeComparators(request : String) : Bool
            return request.includes?("<") || request.includes?(">")

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "includeComparators",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        private def greaterComparator(request : String) : Bool
            return request[0] == '>' && request[1] != '='

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "greaterComparator",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        private def lessComparator(request : String) : Bool
            return request[0] == '<' && request[1] != '='

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "lessComparator",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        private def greaterOrEqualComparator(request : String) : Bool
            return request[0..1] == ">="

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "greaterOrEqualComparator",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        private def lessOrEqualComparator(request : String) : Bool
            return request[0..1] == "<="

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "lessOrEqualComparator",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        private def intervalComparator(request : String) : Bool
            #EXEMPLE: ">=5.0.0 ~ <6.0.0"
            separator = request.includes?(" ~ ")
            comparators = false

            if separator
                startCondition = request.split(" ~ ")[0]
                endCondition = request.split(" ~ ")[1]
                comparators = ( (greaterComparator(startCondition) || greaterOrEqualComparator(startCondition)) && (lessComparator(endCondition) || lessOrEqualComparator(endCondition)) )
            else
                return false
            end

            return (separator && comparators)

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "intervalComparator",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def getVersionByCondition(condition : String, returnMaximum = true) : Software::Information

            temp = Array(Software::Information).new

            if intervalComparator(condition)

                startCondition = condition.split(" ~ ")[0]
                endCondition = condition.split(" ~ ")[1]

                startVersion = startCondition.tr("><=","")
                endVersion = endCondition.tr("><=","")

                startSemanticVersion = SemanticVersion.parse(startVersion)
                endSemanticVersion = SemanticVersion.parse(endVersion)

                firstConditionFulfilledArray = Array(Software::Information).new

                @versions.each do |entry|

                    if greaterComparator(startCondition) && SemanticVersion.parse(entry.version) > startSemanticVersion ||
                        lessComparator(startCondition) && SemanticVersion.parse(entry.version) < startSemanticVersion ||
                        greaterOrEqualComparator(startCondition) && SemanticVersion.parse(entry.version) >= startSemanticVersion ||
                        lessOrEqualComparator(startCondition) && SemanticVersion.parse(entry.version) <= startSemanticVersion

                        firstConditionFulfilledArray.push(entry)
                    end

                end

                firstConditionFulfilledArray.each do |software|

                    if greaterComparator(endCondition) && SemanticVersion.parse(software.version) > endSemanticVersion ||
                        lessComparator(endCondition) && SemanticVersion.parse(software.version) < endSemanticVersion ||
                        greaterOrEqualComparator(endCondition) && SemanticVersion.parse(software.version) >= endSemanticVersion ||
                        lessOrEqualComparator(endCondition) && SemanticVersion.parse(software.version) <= endSemanticVersion

                        temp.push(software)
                    end

                end

            else

                version = condition.tr("><=","")
                semanticVersion = SemanticVersion.parse(version)

                if greaterComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) > semanticVersion}
                elsif lessComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) < semanticVersion}
                elsif greaterOrEqualComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) >= semanticVersion}
                elsif lessOrEqualComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) <= semanticVersion}
                else
                    return Software::Information.new
                end

            end

            return temp.empty? ? Software::Information.new : (returnMaximum ? temp.max_by {|entry| SemanticVersion.parse(entry.version)} : temp.min_by {|entry| SemanticVersion.parse(entry.version)})

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "getVersionByCondition",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def greatestVersion(condition=String.new) : Software::Information
            if @versions.size > 0
                if condition == "" || condition == ">=0.0.0"
                    return @versions.max_by {|entry| SemanticVersion.parse(entry.version)}
                elsif !includeComparators(condition) && condition != ""
                    @versions.each do |software|
                        if software.version == condition
                            return software
                        end
                    end
                else
                    return getVersionByCondition(condition: condition, returnMaximum: true)
                end
            end

            return Software::Information.new

            rescue exception
                ISM::Error.show(className: "AvailableSoftware",
                                functionName: "greatestVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
