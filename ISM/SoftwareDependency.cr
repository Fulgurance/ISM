module ISM

    class SoftwareDependency

        property name : String
        property options : Array(ISM::SoftwareOption)

        def initialize
            @name = String.new
            @version = String.new
            @options = Array(ISM::SoftwareOption).new
        end

        def version=(@version)
        end

        def version
            availableVersion = @version

            if @version.includes?("<") || @version.includes?(">")
                if @version[0] == ">" && @version[1] != "="
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion < temporarySoftwareVersion && availableVersion < temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end

                        end
                    end
                end

                if @version[0] == "<" && @version[1] != "="
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion > temporarySoftwareVersion && availableVersion > temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end

                if @version[0..1] == ">="
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion <= temporarySoftwareVersion && availableVersion <= temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end

                if @version[0..1] == "<="
                    availableVersion = @version.tr("><=","")

                    Ism.softwares.each do |software|
                        if @name == software.name
                            temporaryVersion = @version.tr("><=","")

                            software.versions.each do |information|
                                temporarySoftwareVersion = information.version.tr("><=","")
                                if temporaryVersion >= temporarySoftwareVersion && availableVersion >= temporarySoftwareVersion
                                    availableVersion = temporarySoftwareVersion
                                else
                                    availableVersion = @version
                                end
                            end
                        end
                    end
                end
            end

            return availableVersion
        end

        def getDependencies : Array(ISM::SoftwareDependency)
            dependencies = Array(ISM::SoftwareDependency).new

            Ism.softwares.each do |software|

                if software.name == @name

                    software.versions.each do |version|

                        if @version == version.version
                            dependencies = dependencies + version.dependencies
                            break
                        end

                    end

                end
            end

            return dependencies
        end

        def getInformation : ISM::SoftwareInformation
            dependencyInformation = ISM::SoftwareInformation.new

            Ism.softwares.each do |software|

                if software.name == @name

                    software.versions.each do |version|

                        if @version == version.version
                            dependencyInformation = version
                            break
                        end

                    end

                end
            end

            return dependencyInformation
        end

        def == (other : ISM::SoftwareDependency) : Bool
            return @name == other.name && @version == other.version && @options == other.options
        end

    end

end
