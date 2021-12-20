module ISM

  class Version

    record VersionStructure,
        stage : String,
        majorVersion : String,
        minorVersion : String,
        patchVersion : String do
        include JSON::Serializable
    end

    property stage = ISM::Default::Version::Stage
    property majorVersion = ISM::Default::Version::MajorVersion
    property minorVersion = ISM::Default::Version::MinorVersion
    property patchVersion = ISM::Default::Version::PatchVersion

    def initialize( stage = ISM::Default::Version::Stage,
                    majorVersion = ISM::Default::Version::MajorVersion,
                    minorVersion = ISM::Default::Version::MinorVersion,
                    patchVersion = ISM::Default::Version::PatchVersion)

                    @stage = stage
                    @majorVersion = majorVersion
                    @minorVersion = minorVersion
                    @patchVersion = patchVersion
    end

    def loadVersionFile(loadVersionFilePath = ISM::Default::Filename::Version)
        version = VersionStructure.from_json(File.read(loadVersionFilePath))

        @stage = version.stage
        @majorVersion = version.majorVersion
        @minorVersion = version.minorVersion
        @patchVersion = version.patchVersion
    end

  end

end
