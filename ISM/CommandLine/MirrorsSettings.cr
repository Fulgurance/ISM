module ISM

    class CommandLine

        class MirrorsSettings

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
                    ISM::Error.show(className: "MirrorsSettings",
                                    functionName: "generateConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to generate configuration file to #{path}",
                                    exception: exception)
            end

            def self.loadConfiguration(path = filePath)
                if !File.exists?(path)
                    generateConfiguration(path)
                end

                return from_json(File.read(path))

                rescue exception
                    ISM::Error.show(className: "MirrorsSettings",
                                    functionName: "loadConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to load configuration file from #{path}",
                                    exception: exception)
            end

            def writeConfiguration(path = self.class.filePath)
                file = File.open(path,"w")
                to_json(file)
                file.close

                rescue exception
                    ISM::Error.show(className: "MirrorsSettings",
                                    functionName: "writeConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to write configuration file to #{path}",
                                    exception: exception)
            end

            def setDefaultMirror(@defaultMirror)
                writeConfiguration

                rescue exception
                    ISM::Error.show(className: "MirrorsSettings",
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

end
