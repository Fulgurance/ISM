module ISM

    class AvailableSoftware

        property port : String
        property name : String
        property versions : Array(ISM::SoftwareInformation)

        def initialize(@port = String.new, @name = String.new, @versions = Array(ISM::SoftwareInformation).new)
        end

        def fullName : String
            return "@#{@port}:#{@name}"
        end

        private def includeComparators(request : String) : Bool
            return request.includes?("<") || request.includes?(">")
        end

        private def greaterComparator(request : String) : Bool
            return request[0] == '>' && request[1] != '='
        end

        private def lessComparator(request : String) : Bool
            return request[0] == '<' && request[1] != '='
        end

        private def greaterOrEqualComparator(request : String) : Bool
            return request[0..1] == ">="
        end

        private def lessOrEqualComparator(request : String) : Bool
            return request[0..1] == "<="
        end

        private def intervalComparator(request : String) : Bool
            #EXEMPLE: "{>=5.0.0 ~ <6.0.0}"
            brackets = (request[0] == "{" && request[0] == "}")
            separator = request.includes?(" ~ ")

            if request.size > 17
                startCondition = request.split(" ~ ")[0][1..-1]
                endCondition = request.split(" ~ ")[1][0..-2]
                comparators = ( (greaterComparator(startCondition) || greaterOrEqualComparator(startCondition)) && (lessComparator(endCondition) || lessOrEqualComparator(endCondition)) )
            else
                return false
            end

            return (brackets && separator && comparators)
        end

        def getVersionByCondition(condition : String, returnMaximum = true) : ISM::SoftwareInformation

            version = condition.tr("><=","")
            semanticVersion = SemanticVersion.parse(version)

            if greaterComparator(condition) && !@versions.empty?
                temp = @versions.select {|entry| SemanticVersion.parse(entry.version) > semanticVersion}
            elsif lessComparator(condition)
                temp = @versions.select {|entry| SemanticVersion.parse(entry.version) < semanticVersion}
            elsif greaterOrEqualComparator(condition)
                temp = @versions.select {|entry| SemanticVersion.parse(entry.version) >= semanticVersion}
            elsif lessOrEqualComparator(condition)
                temp = @versions.select {|entry| SemanticVersion.parse(entry.version) <= semanticVersion}
            elsif intervalComparator(condition)
                startCondition = condition.split(" ~ ")[0][1..-1]
                endCondition = condition.split(" ~ ")[1][0..-2]

                startVersion = startCondition.tr("><=","")
                endVersion = endCondition.tr("><=","")

                startSemanticVersion = SemanticVersion.parse(startVersion)
                endSemanticVersion = SemanticVersion.parse(endVersion)

                intervalStart = getVersionByCondition(condition: startCondition, returnMaximum: false)
                intervalEnd = getVersionByCondition(condition: endCondition, returnMaximum: true)

                temp = @versions.select {|entry| SemanticVersion.parse(entry.version) >= startSemanticVersion && SemanticVersion.parse(entry.version) <= endSemanticVersion}

                return temp.max_by {|entry| SemanticVersion.parse(entry.version)}
            else
                return ISM::SoftwareInformation.new
            end

            return temp.empty? ? ISM::SoftwareInformation.new : (returnMaximum ? temp.max_by {|entry| SemanticVersion.parse(entry.version)} : temp.min_by {|entry| SemanticVersion.parse(entry.version)})
        end

        def greatestVersion(condition=String.new) : ISM::SoftwareInformation
            if @versions.size > 0
                if condition == "" || condition == ">=0.0.0"
                    return @versions.max_by {|entry| SemanticVersion.parse(entry.version)}
                elsif !includeComparators(condition) && condition != ""
                    @versions.each do |software|
                        if software.version == condition
                            return software
                        end
                    end
                elsif intervalComparator(condition)
                    startCondition = condition.split(" ~ ")[0][1..-1]
                    endCondition = condition.split(" ~ ")[1][0..-2]

                    startVersion = startCondition.tr("><=","")
                    endVersion = endCondition.tr("><=","")

                    startSemanticVersion = SemanticVersion.parse(startVersion)
                    endSemanticVersion = SemanticVersion.parse(endVersion)

                    intervalStart = getVersionByCondition(condition: startCondition, returnMaximum: false)
                    intervalEnd = getVersionByCondition(condition: endCondition, returnMaximum: true)

                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) >= startSemanticVersion && SemanticVersion.parse(entry.version) <= endSemanticVersion}

                    return temp.max_by {|entry| SemanticVersion.parse(entry.version)}
                else
                    return getVersionByCondition(condition: condition, returnMaximum: true)
                end
                return ISM::SoftwareInformation.new
            else
                return ISM::SoftwareInformation.new
            end
        end

    end

end
