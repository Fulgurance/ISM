module ISM

    class CommandLineMirrorsSettings

        module Default

            DefaultMirror = "Uk"
            MirrorsSettingsFilePath = "#{Path::SettingsDirectory}#{Filename::MirrorsSettings}"

        end

        include JSON::Serializable

        property defaultMirror : String

        def initialize(@defaultMirror = Default::DefaultMirror)
        end

        def self.filePath : String
            return Ism.settings.rootPath+Default::MirrorsSettingsFilePath
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "CommandLineMirrorsSettings",
                                functionName: "generateConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))

            rescue exception
                ISM::Error.show(className: "CommandLineMirrorsSettings",
                                functionName: "loadConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def writeConfiguration(path = self.class.filePath)
            file = File.open(path,"w")
            to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "CommandLineMirrorsSettings",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setDefaultMirror(@defaultMirror)
            writeConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineMirrorsSettings",
                                functionName: "setDefaultMirror",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def sourcesLink : String
            return ISM::Mirror.sourcesLink(@defaultMirror)
        end

    end

end
