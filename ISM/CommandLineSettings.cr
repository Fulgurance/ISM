module ISM

    class CommandLineSettings

        record Settings,
            rootPath : String,
            systemName : String,
            targetName : String,
            architecture : String,
            target : String,
            makeOptions : String,
            buildOptions : String do
            include JSON::Serializable
        end

        property    rootPath : String
        property    systemName : String
        property    targetName : String
        property    architecture : String
        getter      target : String
        property    makeOptions : String
        property    buildOptions : String

        def initialize( @rootPath = ISM::Default::CommandLineSettings::RootPath,
                        @systemName = ISM::Default::CommandLineSettings::SystemName,
                        @targetName = ISM::Default::CommandLineSettings::TargetName,
                        @architecture = ISM::Default::CommandLineSettings::Architecture,
                        @target = ISM::Default::CommandLineSettings::Target,
                        @makeOptions = ISM::Default::CommandLineSettings::MakeOptions,
                        @buildOptions = ISM::Default::CommandLineSettings::BuildOptions)
        end

        def loadSettingsFile
            information = Settings.from_json(File.read(ISM::Default::CommandLineSettings::SettingsFilePath))
      
            @rootPath = information.rootPath
            @systemName = information.systemName
            @targetName = information.targetName
            @architecture = information.architecture
            @target = information.target
            @makeOptions = information.makeOptions
            @buildOptions = information.buildOptions
        end

        def writeSettingsFile
            settings = Settings.new(@rootPath,
                                    @systemName,
                                    @targetName,
                                    @architecture,
                                    @target,
                                    @makeOptions,
                                    @buildOptions)

            file = File.open(ISM::Default::CommandLineSettings::SettingsFilePath,"w")
            settings.to_json(file)
            file.close
        end

        def setRootPath(@rootPath)
            writeSettingsFile
        end

        def setSystemName(@systemName)
            writeSettingsFile
        end

        def setTargetName(@targetName)
            writeSettingsFile
            setTarget
        end

        def setArchitecture(@architecture)
            writeSettingsFile
            setTarget
        end

        def setTarget
            @target = @architecture + "-" + @targetName + "-" + "linux-gnu"
            writeSettingsFile
        end

        def setMakeOptions(@makeOptions)
            writeSettingsFile
        end

        def setBuildOptions(@buildOptions)
            writeSettingsFile
        end

        def temporaryPath
            "#{@rootPath}#{ISM::Default::Path::TemporaryDirectory}"
        end

        def sourcesPath
            return "#{@rootPath}#{ISM::Default::Path::SourcesDirectory}"
        end

        def toolsPath
            return "#{@rootPath}#{ISM::Default::Path::ToolsDirectory}"
        end

    end

end
