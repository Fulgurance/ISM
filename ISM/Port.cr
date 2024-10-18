module ISM

    class Port

        include JSON::Serializable

        property name : String
        property url : String

        def initialize(@name = String.new,@url = String.new)
        end

        def self.filePathPrefix : String
            return Ism.settings.rootPath+ISM::Default::Path::PortsDirectory
        end

        def self.directoryPathPrefix : String
            return Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory
        end

        def self.exists(name : String) : Bool
            Dir.glob("#{self.filePathPrefix}/*").each do |port|
                filename = port[0..-6]

                if filename.downcase == name.downcase || "@#{filename.downcase}" == name.downcase
                    return true
                end
            end

            return false
        end

        def self.delete(name : String)
            Dir.glob("#{self.filePathPrefix}/*").each do |port|
                filename = port[0..-6]

                if filename.downcase == name.downcase || "@#{filename.downcase}" == name.downcase
                    File.delete(self.filePathPrefix+filename+".json")
                    FileUtils.rm_r(self.directoryPathPrefix+filename)
                    break
                end
            end
        end

        def self.filePath(name : String) : String
            return filePathPrefix+name+".json"
        end

        def self.directoryPath(name : String) : String
            return directoryPathPrefix+name
        end

        def self.loadConfiguration(path = filePath)
            return from_json(File.read(path))
        end

        def filePath : String
            return self.class.filePathPrefix+@name+".json"
        end

        def directoryPath : String
            return self.class.directoryPathPrefix+@name
        end

        def writeConfiguration
            file = File.open(filePath,"w")
            to_json(file)
            file.close
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
        end

        def synchronize : Process
            return Process.new( "git pull origin #{Ism.portsSettings.targetVersion}",
                                shell: true,
                                chdir: directoryPath)
        end

    end

end
