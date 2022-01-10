module ISM

  class SoftwareDependency

    property name : String
    property version : String
    property options : Array(ISM::SoftwareOption)

    def initialize
      @name = String.new
      @version = String.new
      @options = Array(ISM::SoftwareOption).new
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

  end

end