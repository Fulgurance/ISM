module ISM
  class SoftwareDependency
    def_clone

    include JSON::Serializable

    property port : String
    property name : String
    property options : Array(String)

    def initialize(@port = String.new,
                   @name = String.new,
                   @version = String.new,
                   @options = Array(String).new)
    end

    def getEnabledPass : String
      @options.each do |option|
        if option.starts_with?(/Pass[0-9]/)
          return option
        end
      end

      String.new
    end

    def fullName : String
      "@#{@port}:#{@name}"
    end

    def fullVersionName : String
      "#{fullName}-#{version}"
    end

    def hiddenName : String
      passName = getEnabledPass
      "@#{@port}:#{versionName}#{passName == "" ? "" : "-#{passName}"}"
    end

    def version=(@version)
    end

    def versionName
      @name + "-" + version
    end

    def version
      Ism.getAvailableSoftware(fullName).greatestVersion(@version).version
    end

    def requiredVersion : String
      @version
    end

    def information : ISM::SoftwareInformation
      dependencyInformation = Ism.getSoftwareInformation(fullVersionName)

      if dependencyInformation.isValid
        @options.each do |option|
          dependencyInformation.enableOption(option)
        end
      else
        dependencyInformation = ISM::SoftwareInformation.new(port: @port, name: @name, version: @version)
      end

      dependencyInformation
    end

    def installedFiles
      softwaresList = Array(ISM::SoftwareDependency).new

      @installedSoftwares.each do |software|
        if software.toSoftwareDependency.hiddenName == hiddenName
          return software.installedFiles
        end
      end
    end

    def dependencies(allowDeepSearch = false) : Array(ISM::SoftwareDependency)
      information.dependencies(allowDeepSearch)
    end

    def builtSoftwareDirectoryPath : String
      information.builtSoftwareDirectoryPath
    end

    def requireFilePath : String
      information.requireFilePath
    end

    def filePath : String
      information.filePath
    end

    def ==(other : ISM::SoftwareDependency) : Bool
      hiddenName == other.hiddenName &&
        version == other.version &&
        @options == other.options
    end
  end
end
