module ISM

    class AvailableSoftware

        property name : String
        property versions : Array(ISM::SoftwareInformation)

        def initialize(@name = String.new, @versions = Array(ISM::SoftwareInformation).new)
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

        def greatestVersion(condition=String.new) : ISM::SoftwareInformation
            if condition == "" || condition == ">=0.0.0"
                return @versions.max_by {|entry| SemanticVersion.parse(entry.version)}
            elsif !includeComparators(condition) && condition != ""
                @versions.each do |software|
                    if software.version == condition
                        return software
                    end
                end
            else
                version = condition.tr("><=","")
                semanticVersion = SemanticVersion.parse(version)

                if greaterComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) > semanticVersion}
                    return temp.max_by {|entry| SemanticVersion.parse(entry.version)}
                end

                if lessComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) < semanticVersion}
                    return temp.max_by {|entry| SemanticVersion.parse(entry.version)}
                end

                if greaterOrEqualComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) >= semanticVersion}
                    return temp.max_by {|entry| SemanticVersion.parse(entry.version)}
                end

                if lessOrEqualComparator(condition)
                    temp = @versions.select {|entry| SemanticVersion.parse(entry.version) <= semanticVersion}
                    return temp.max_by {|entry| SemanticVersion.parse(entry.version)}
                end
            end

            return ISM::SoftwareInformation.new
        end

    end

end
