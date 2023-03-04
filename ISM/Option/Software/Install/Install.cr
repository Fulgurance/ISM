module ISM

    module Option

        class SoftwareInstall < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::SoftwareInstall::ShortText,
                        ISM::Default::Option::SoftwareInstall::LongText,
                        ISM::Default::Option::SoftwareInstall::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    userRequest = ARGV[2+Ism.debugLevel..-1].uniq
                    requestedSoftwares = Ism.getRequestedSoftwares(userRequest)

                    #No match found
                    if userRequest.size != requestedSoftwares.size


                        exit 1
                    end

                    #No available version found
                    if requestedSoftwares.any? {|software| software.version == ""}


                        exit 1
                    end

                    dependenciesTable = getDependenciesTable(requestedSoftwares)
                    neededSoftwares = getSortedDependencies(dependenciesTable)

                    showCalculationDoneMessage

                    showNeededSoftwares(neededSoftwares)

                end
            end

            def getRequiredDependencies(software : ISM::SoftwareInformation) : Array(ISM::SoftwareDependency)
                dependencies = Hash(String,SoftwareDependency).new

                currentDependencies = software.dependencies
                nextDependencies = Array(ISM::SoftwareDependency).new

                loop do

                    if currentDependencies.empty?
                        break
                    end

                    currentDependencies.each do |dependency|

                        #Inextricable dependencies or need multiple version or just need to fusion options
                        if dependencies.has_key? dependency.hiddenName

                            #Inextricable dependencies
                            if dependencies[dependency.hiddenName] == dependency

                                exit 1
                            else
                                #Multiple versions of single software requested
                                if dependencies[dependency.hiddenName].version != dependency.version


                                    exit 1
                                #When versions are equal but options are differents
                                else
                                #Fusion of all options and add it as well to the nextDependencies

                                end
                            end
                        else
                            dependencies[dependency.hiddenName] = dependency
                            nextDependencies += dependency.dependencies
                        end

                    end

                    currentDependencies = nextDependencies.dup
                    nextDependencies.clear

                end

                return dependencies.values
            end

            def getDependenciesTable(softwareList : Array(ISM::SoftwareInformation)) : Hash(ISM::SoftwareDependency,Array(ISM::SoftwareDependency))
                dependenciesTable = Hash(ISM::SoftwareDependency,Array(ISM::SoftwareDependency)).new

                softwareList.each do |software|
                    dependenciesTable[software.toSoftwareDependency] = getRequiredDependencies(software)
                end

                return dependenciesTable
            end

            def getSortedDependencies(dependenciesTable : Hash(ISM::SoftwareDependency,Array(ISM::SoftwareDependency))) : Array(ISM::SoftwareDependency)
                result = Array(ISM::SoftwareDependency).new

                dependenciesTable.to_a.sort_by { |k, v| v.size }.each do |item|
                    result << item[0]
                end

                return result
            end

            def showCalculationDoneMessage
                print "#{ISM::Default::Option::SoftwareInstall::CalculationDoneText.colorize(:green)}\n"
            end

            def showNeededSoftwares(neededSoftwares : Array(ISM::SoftwareDependency))
                neededSoftwares.each do |software|
                    puts "\t#{software.version}-#{software.version}"+software.options.to_s
                end
            end

        end

    end

end
