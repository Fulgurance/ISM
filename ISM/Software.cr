module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String
        property buildDirectory : Bool

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceDirectoryName = getMainSourceDirectoryName
            @buildDirectory = false
        end

        def getMainSourceDirectoryName
            result = String.new

            if !@information.downloadLinks.empty?
                result = @information.downloadLinks[0]
                result = result.lchop(result[0..result.rindex("/")])
                if result[-7..-1] == ".tar.gz" || result[-7..-1] == ".tar.xz"
                    result = result[0..-8]+"/"
                end
                if result[-8..-1] == ".tar.bz2"
                    result = result[0..-9]+"/"
                end
            end
            return result
        end

        def workDirectoryPath(relatedToChroot = true) : String
            return (relatedToChroot ? Ism.settings.installByChroot : false) ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+"/"+@information.name+"/"+@information.version
        end

        def mainWorkDirectoryPath(relatedToChroot = true) : String
            return workDirectoryPath(relatedToChroot)+"/"+@mainSourceDirectoryName
        end

        def buildDirectoryPath(relatedToChroot = true) : String
            return mainWorkDirectoryPath(relatedToChroot)+"/"+"#{@buildDirectory ? "/build" : ""}"
        end

        def builtSoftwareDirectoryPath(relatedToChroot = true) : String
            return (relatedToChroot ? Ism.settings.installByChroot : false) ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}/#{@information.builtSoftwareDirectoryPath}"
        end

        def download
            Ism.notifyOfDownload(@information)

            if Dir.exists?(workDirectoryPath(false))
                deleteDirectoryRecursively(workDirectoryPath(false))
            end
            makeDirectory(workDirectoryPath(false))

            @information.downloadLinks.each do |link|
                downloadSource(link)
            end

            @information.patchesLinks.each do |link|
                downloadSource(link)
            end
        end

        def downloadSource(link : String)
            process = Process.run("wget",   args: [link],
                                            output: :inherit,
                                            error: :inherit,
                                            chdir: workDirectoryPath(false))
            if !process.success?
                Ism.notifyOfDownloadError(link)
                exit 1
            end
        end
        
        def check
            Ism.notifyOfCheck(@information)
            @information.downloadLinks.each_with_index do |source, index|
                checkSource(workDirectoryPath(false)+"/"+source.lchop(source[0..source.rindex("/")]),@information.md5sums[index])
            end
        end

        def checkSource(archive : String, md5sum : String)
            digest = Digest::MD5.new
            digest.file(archive)
            archiveMd5sum = digest.hexfinal

            if archiveMd5sum != md5sum
                Ism.notifyOfCheckError(archive, md5sum)
                exit 1
            end
        end
        
        def extract
            Ism.notifyOfExtract(@information)
            @information.downloadLinks.each do |source|
                extractSource(source.lchop(source[0..source.rindex("/")]))
            end
        end

        def extractSource(archive : String)
            process = Process.run("tar",args: [ "-xf",
                                                archive],
                                        error: :inherit,
                                        chdir: workDirectoryPath(false))
            if !process.success?
                Ism.notifyOfExtractError(archive)
                exit 1
            end
        end
        
        def patch
            Ism.notifyOfPatch(@information)
            @information.patchesLinks.each do |patch|
                patchFileName = patch.lchop(patch[0..patch.rindex("/")])
                if patchFileName[-6..-1] != ".patch"
                    moveFile("#{workDirectoryPath(false)}/#{patchFileName}","#{workDirectoryPath(false)}/#{patchFileName}.patch")
                    patchFileName = "#{patchFileName}.patch"
                end
                applyPatch(patchFileName)
            end
        end
        
        def applyPatch(patch : String)
            process = Process.run("patch",  args: ["-Np1","-i","#{workDirectoryPath(false)}/#{patch}"],
                                            error: :inherit,
                                            chdir: mainWorkDirectoryPath(false))
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                exit 1
            end
        end

        def prepare
            Ism.notifyOfPrepare(@information)
            if !Dir.exists?(buildDirectoryPath(false))
                makeDirectory(buildDirectoryPath(false))
            end
        end

        def generateEmptyFile(path : String)
            begin
                FileUtils.touch(path)
            rescue error
                Ism.notifyOfGenerateEmptyFileError(path, error)
                exit 1
            end
        end

        def moveFile(path : String, newPath : String)
            begin
                FileUtils.mv(path, newPath)
            rescue error
                Ism.notifyOfMoveFileError(path, newPath, error)
                exit 1
            end
        end

        def makeDirectory(directory : String)
            begin
                FileUtils.mkdir_p(directory)
            rescue error
                Ism.notifyOfMakeDirectoryError(directory, error)
                exit 1
            end
        end

        def deleteDirectory(directory : String)
            begin
                Dir.delete(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryError(directory, error)
                exit 1
            end
        end

        def deleteDirectoryRecursively(directory : String)
            begin
                FileUtils.rm_r(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryRecursivelyError(directory, error)
                exit 1
            end
        end

        def fileReplaceText(filePath : String, text : String, newText : String)
            begin
                content = File.read_lines(filePath)

                File.open(filePath,"w") do |file|
                    content.each do |line|
                        if line.includes?(text)
                            file << line.gsub(text, newText)+"\n"
                        else
                            file << line+"\n"
                        end
                    end
                end
            rescue error
                Ism.notifyOfFileReplaceTextError(filePath, text, newText, error)
                exit 1
            end
        end

        def fileReplaceLineContaining(filePath : String, text : String, newLine : String)
            begin
                content = File.read_lines(filePath)

                File.open(filePath,"w") do |file|
                    content.each do |line|
                        if line.includes?(text)
                            file << newLine+"\n"
                        else
                            file << line+"\n"
                        end
                    end
                end
            rescue error
                Ism.notifyOfFileReplaceLineContainingError(filePath, text, newLine, error)
                exit 1
            end
        end

        def fileReplaceTextAtLineNumber(filePath : String, text : String, newText : String,lineNumber : UInt64)
            begin
                content = File.read_lines(filePath)

                File.open(filePath,"w") do |file|
                    content.each_with_index do |line, index|
                        if !(index+1 == lineNumber)
                            file << line+"\n"
                        else
                            file << line.gsub(text, newText)+"\n"
                        end
                    end
                end
            rescue error
                Ism.notifyOfReplaceTextAtLineNumberError(filePath, text, newText, lineNumber, error)
                exit 1
            end
        end

        def fileDeleteLine(filePath : String, lineNumber : UInt64)
            begin
                content = File.read_lines(filePath)

                File.open(filePath,"w") do |file|
                    content.each_with_index do |line, index|
                        if !(index+1 == lineNumber)
                            file << line+"\n"
                        end
                    end
                end
            rescue error
                Ism.notifyOfFileDeleteLineError(filePath, lineNumber, error)
                exit 1
            end
        end

        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath, error)
                exit 1
            end
            return content
        end

        def fileWriteData(filePath : String, data : String)
            begin
                File.write(filepath, data)
            rescue error
                Ism.notifyOfFileWriteDataError(filePath, error)
                exit 1
            end
        end

        def fileAppendData(filePath : String, data : String)
            begin
                File.open(filePath,"a") do |file|
                    file.puts(data)
                end
            rescue error
                Ism.notifyOfFileAppendDataError(filePath, error)
                exit 1
            end
        end 

        def makeLink(path : String, targetPath : String, linkType : Symbol)
            begin
                case linkType
                when :hardLink
                    FileUtils.ln(path, targetPath)
                when :symbolicLink
                    FileUtils.ln_s(path, targetPath)
                when :symbolicLinkByOverwrite
                    FileUtils.ln_sf(path, targetPath)
                else
                    exit 1
                end
            rescue error
                Ism.notifyOfMakeSymbolicLinkError(path, targetPath, error)
                exit 1
            end
        end

        def copyFile(path : String | Enumerable(String), targetPath : String)
            begin
                FileUtils.cp(path, targetPath)
            rescue error
                Ism.notifyOfCopyFileError(path, targetPath, error)
                exit 1
            end
        end

        def copyDirectory(path : String, targetPath : String)
            begin
                FileUtils.cp_r(path, targetPath)
            rescue error
                Ism.notifyOfCopyDirectoryError(path, targetPath, error)
                exit 1
            end
        end

        def deleteFile(path : String)
            begin
                File.delete(path)
            rescue error
                Ism.notifyOfDeleteFileError(path, error)
                exit 1
            end
        end

        def replaceTextAllFilesNamed(path : String, filename : String, text : String, newText : String)
            begin
                Dir.glob("#{path}/*") do |file_path|
                    if File.file?(file_path) && file_path == "#{path}/#{filename}".squeeze("/")
                        fileReplaceText(file_path, text, newText)
                    end
                end
            rescue error
                Ism.notifyOfReplaceTextAllFilesNamedError(path, filename, text, newText, error)
                exit 1
            end
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            begin
                replaceTextAllFilesNamed(path, filename, text, newText)
                Dir.glob("#{path}/*") do |file_path|
                    if File.directory?(file_path)
                        replaceTextAllFilesNamed(file_path, filename, text, newText)
                    end
                end
            rescue error
                Ism.notifyOfReplaceTextAllFilesRecursivelyNamedError(path, filename, text, newText, error)
                exit 1
            end
        end

        def deleteAllFilesFinishing(path : String, text : String)
            begin
                Dir.glob("#{path}/*") do |file_path|
                    if File.file?(file_path) && file_path[-text.size..-1] == text
                        deleteFile(file_path)
                    end
                end
            rescue error
                Ism.notifyOfDeleteAllFilesFinishingError(path, text, error)
                exit 1
            end
        end

        def deleteAllFilesRecursivelyFinishing(path : String, text : String)
            begin
                deleteAllFilesFinishing(path,text)
                Dir.glob("#{path}/*") do |file_path|
                    if File.directory?(file_path)
                        deleteAllFilesFinishing(file_path,text)
                    end
                end
            rescue error
                Ism.notifyOfDeleteAllFilesRecursivelyFinishingError(path, text, error)
                exit 1
            end
        end

        def deleteAllHiddenFiles(path : String)
            begin
                Dir.glob("#{path}/.*", match_hidden: true) do |file_path|
                    if File.file?(file_path)
                        deleteFile(file_path)
                    end
                end
            rescue error
                Ism.notifyOfDeleteAllHiddenFilesError(path, error)
                exit 1
            end
        end

        def deleteAllHiddenFilesRecursively(path : String)
            begin
                deleteAllHiddenFiles(path)
                Dir.glob("#{path}/*") do |file_path|
                    if File.directory?(file_path)
                        deleteAllHiddenFiles(file_path)
                    end
                end
            rescue error
                Ism.notifyOfDeleteAllHiddenFilesRecursivelyError(path, error)
                exit 1
            end
        end

        def fileMakeinfo(arguments : Array(String), path = String.new)
            process = Process.run("makeinfo",   args: arguments,
                                                chdir: path)

            if !process.success?
                Ism.notifyOfFileMakeinfoError(path)
                exit 1
            end
        end

        def runChrootTasks(chrootTasks) : Process::Status
            File.write(Ism.settings.rootPath+"/"+ISM::Default::Filename::Task, chrootTasks)

            process = Process.run("chmod",  args: [ "+x",
                                                    "#{Ism.settings.rootPath}/#{ISM::Default::Filename::Task}"],
                                            output: :inherit,
                                            error: :inherit,
                                            shell: true)

            process = Process.run("sudo",   args: [ "chroot",
                                                    Ism.settings.rootPath,
                                                    "./#{ISM::Default::Filename::Task}"],
                                            output: :inherit,
                                            error: :inherit,
                                            shell: true)

            return process
        end

        def runScript(file : String, arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            scriptCommand = "./#{file}"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootMakeCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{scriptCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootMakeCommand)
            else
                process = Process.run(  scriptCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunScriptError(file, path)
                exit 1
            end
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments : Array(String), path = String.new, configureDirectory = String.new, environment = Hash(String, String).new)
            if @buildDirectory
                configureCommand = "../#{configureDirectory}/configure "
            else
                configureCommand = "./#{configureDirectory}/configure "
            end

            configureCommand += arguments.join(" ")
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootConfigureCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{configureCommand}
                CODE

                process = runChrootTasks(chrootConfigureCommand)
            else
                process = Process.run(  configureCommand,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end

            if !process.success?
                Ism.notifyOfConfigureError(path)
                exit 1
            end
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makePerlSource(path = String.new)
            if Ism.settings.installByChroot
                chrootMakeCommand = <<-CODE
                #!/bin/bash
                cd #{path} && perl Makefile.PL
                CODE

                process = runChrootTasks(chrootMakeCommand)
            else
                process = Process.run("perl",   args: ["Makefile.PL"],
                                                output: :inherit,
                                                error: :inherit,
                                                chdir: path)
            end
            if !process.success?
                Ism.notifyOfMakePerlSourceError(path)
                exit 1
            end
        end

        def makeSource(arguments : Array(String), path = String.new)
            if Ism.settings.installByChroot
                chrootMakeCommand = <<-CODE
                #!/bin/bash
                cd #{path} && make #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootMakeCommand)
            else
                process = Process.run("make",   args: arguments,
                                                output: :inherit,
                                                error: :inherit,
                                                chdir: path)
            end
            if !process.success?
                Ism.notifyOfMakeSourceError(path)
                exit 1
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def install
            Ism.notifyOfInstall(@information)

            filesList = Dir.glob("#{builtSoftwareDirectoryPath(false)}/**/*")

            filesList.each do |entry|
                finalDestination = entry.delete_at(1,builtSoftwareDirectoryPath(false).size-1)
                if File.directory?(entry)
                    if !Dir.exists?(finalDestination)
                        makeDirectory(finalDestination)
                    end
                else
                    copyFile(entry,finalDestination)
                end
            end
        end
        
        def clean
            Ism.notifyOfClean(@information)
            deleteDirectoryRecursively(workDirectoryPath(false))
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
            information.installedFiles.each do |file|
                deleteFile(Ism.settings.rootPath+file)
            end
        end

        def option?(optionName : String) : Bool
            result = false
            @information.options.each do |option|
                if optionName == option.name
                    result = option.active
                end
            end
            return result
        end

        def architecture?(architecture : String) : Bool
            return Ism.settings.architecture == architecture
        end

    end

end
