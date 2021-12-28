module ISM

  class Version

    record VersionStructure,
        stage : String,
        majorVersion : String,
        minorVersion : String,
        patchVersion : String do
        include JSON::Serializable
    end

    property stage : String
    property majorVersion : String
    property minorVersion : String
    property patchVersion : String

    def initialize
      @stage = String.new
      @majorVersion = String.new
      @minorVersion = String.new
      @patchVersion = String.new
    end

    def loadVersionFile
        version = VersionStructure.from_json(File.read(ISM::Default::Filename::Version))

        @stage = version.stage
        @majorVersion = version.majorVersion
        @minorVersion = version.minorVersion
        @patchVersion = version.patchVersion
    end

  end

end
