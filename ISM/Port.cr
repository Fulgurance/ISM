module ISM

    class Port

        include JSON::Serializable

        property name : String
        property url : String

        def initialize( @name = String.new,
                        @url = String.new)
        end

        def self.filePathPrefix : String
            return Ism.settings.rootPath+ISM::Default::Path::PortsDirectory
        end

        def self.directoryPathPrefix : String
            return Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory
        end

        def self.exists(name : String) : Bool
            Dir.glob("#{self.filePathPrefix}/*").each do |port|
                filename = port.sub(self.filePathPrefix,"")[0..-6]

                if filename.downcase == name.downcase || "@#{filename.downcase}" == name.downcase
                    return true
                end
            end

            return false

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "exists",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def self.delete(name : String)
            Dir.glob("#{self.filePathPrefix}/*").each do |port|
                filename = port.sub(self.filePathPrefix,"")[0..-6]

                if filename.downcase == name.downcase || "@#{filename.downcase}" == name.downcase
                    File.delete(self.filePathPrefix+filename+".json")
                    FileUtils.rm_r(self.directoryPathPrefix+filename)
                    break
                end
            end

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "delete",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def self.filePath(name : String) : String
            return filePathPrefix+name+".json"
        end

        def self.directoryPath(name : String) : String
            return directoryPathPrefix+name
        end

        def self.loadConfiguration(path = filePath)
            return from_json(File.read(path))

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "loadConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def self.softwareNumber(name : String) : Int32
            return Dir.glob("#{self.directoryPath(name)}/*").size

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "softwareNumber",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def filePath : String
            return self.class.filePathPrefix+@name+".json"
        end

        def directoryPath : String
            return self.class.directoryPathPrefix+@name
        end

        def softwareNumber
            return self.class.softwareNumber(@name)
        end

        def writeConfiguration
            file = File.open(filePath,"w")
            to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def isAvailable : Bool
            process = Process.new(  "git ls-remote",
                                    shell: true,
                                    chdir: directoryPath)
            result = process.wait

            return result.success?

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "isAvailable",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def open : Bool
            Dir.mkdir_p(directoryPath)

            Process.run("git init",
                        shell: true,
                        chdir: directoryPath)

            Process.run("git remote add origin #{@url}",
                        shell: true,
                        chdir: directoryPath)

            if isAvailable
                writeConfiguration
                return true
            else
                FileUtils.rm_r(directoryPath)
                return false
            end

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "open",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def synchronize : Process
            Process.new("git reset --hard",
                        shell: true,
                        chdir: directoryPath)

            if isAvailable
                return Process.new( "git pull origin master",
                                    shell: true,
                                    chdir: directoryPath)
            else
                Ism.printErrorNotification(ISM::Default::Port::SynchronizeTextError1+"#{@name.colorize(:red)}"+ISM::Default::Port::SynchronizeTextError2+"#{@url.colorize(:red)}"+ISM::Default::Port::SynchronizeTextError3,nil)

                self.class.delete(@name)

                return Process.new( "true",
                                    shell: true,
                                    chdir: directoryPath)
            end

            rescue exception
                ISM::Error.show(className: "Port",
                                functionName: "synchronize",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
