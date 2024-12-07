module ISM

    class Port

        include JSON::Serializable

        property name : String
        property url : String

        def initialize(@name = String.new,@url = String.new)
        end

        def self.filePathPrefix : String
            return Ism.settings.rootPath+ISM::Default::Path::PortsDirectory

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.directoryPathPrefix : String
            return Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.exists(name : String) : Bool
            Dir.glob("#{self.filePathPrefix}/*").each do |port|
                filename = port.sub(self.filePathPrefix,"")[0..-6]

                if filename.downcase == name.downcase || "@#{filename.downcase}" == name.downcase
                    return true
                end
            end

            return false

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.filePath(name : String) : String
            return filePathPrefix+name+".json"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.directoryPath(name : String) : String
            return directoryPathPrefix+name

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.loadConfiguration(path = filePath)
            return from_json(File.read(path))

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.softwareNumber(name : String) : Int32
            return Dir.glob("#{self.directoryPath(name)}/*").size

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def filePath : String
            return self.class.filePathPrefix+@name+".json"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def directoryPath : String
            return self.class.directoryPathPrefix+@name

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def softwareNumber
            return self.class.softwareNumber(@name)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def writeConfiguration
            file = File.open(filePath,"w")
            to_json(file)
            file.close

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def open : Bool
            Dir.mkdir_p(directoryPath)

            Process.run("git init",
                        shell: true,
                        chdir: directoryPath)
            Process.run("git remote add origin #{@url}",
                        shell: true,
                        chdir: directoryPath)

            process = Process.new(  "git ls-remote",
                                    shell: true,
                                    chdir: directoryPath)
            result = process.wait

            if result.success?
                writeConfiguration
            else
                FileUtils.rm_r(directoryPath)
            end

            return result.success?

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def synchronize : Process
            Process.new("git reset --hard",
                        shell: true,
                        chdir: directoryPath)

            return Process.new( "git pull --depth 1 origin #{Ism.portsSettings.targetVersion}",
                                shell: true,
                                chdir: directoryPath)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
