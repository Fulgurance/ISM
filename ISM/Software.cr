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

        def workDirectoryPath : String
            return Ism.settings.sourcesPath+"/"+@information.name+"/"+@information.version
        end

        def mainWorkDirectoryPath : String
            return workDirectoryPath+"/"+@mainSourceDirectoryName
        end

        def buildDirectoryPath : String
            return mainWorkDirectoryPath+"/"+"#{@buildDirectory ? "/build" : ""}"
        end

        def download
            Ism.notifyOfDownload(@information)

            if Dir.exists?(workDirectoryPath)
                deleteDirectoryRecursively(workDirectoryPath)
            end
            makeDirectory(workDirectoryPath)

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
                                            chdir: workDirectoryPath)
            if !process.success?
                Ism.notifyOfDownloadError(link)
                exit 1
            end
        end
        
        def check
            Ism.notifyOfCheck(@information)
        end
        
        def extract
            Ism.notifyOfExtract(@information)
            @information.downloadLinks.each do |source|
                extractSource(source.lchop(source[0..source.rindex("/")]))
            end
        end

        def extractSource(archive : String)
            process = Process.run("tar",args: ["-xf", archive],
                                        chdir: workDirectoryPath)
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
                    moveFile("#{workDirectoryPath}/#{patchFileName}","#{workDirectoryPath}/#{patchFileName}.patch")
                    patchFileName = "#{patchFileName}.patch"
                end
                applyPatch(patchFileName)
            end
        end
        
        def applyPatch(patch : String)
            process = Process.run("patch",  args: ["-Np1","-i","#{workDirectoryPath}/#{patch}"],
                                            chdir: mainWorkDirectoryPath)
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                exit 1
            end
        end

        def prepare
            Ism.notifyOfPrepare(@information)
            if !Dir.exists?(buildDirectoryPath)
                makeDirectory(buildDirectoryPath)
            end
        end

        def moveFile(path : String, newPath : String)
            begin
                FileUtils.mv(path, newPath)
            rescue error
                Ism.notifyOfMoveFileError(path, newPath)
                pp error
                exit 1
            end
        end

        def makeDirectory(directory : String)
            begin
                FileUtils.mkdir_p(directory)
            rescue error
                Ism.notifyOfMakeDirectoryError(directory)
                pp error
                exit 1
            end
        end

        def deleteDirectory(directory : String)
            begin
                Dir.delete(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryError(directory)
                pp error
                exit 1
            end
        end

        def deleteDirectoryRecursively(directory : String)
            begin
                FileUtils.rm_r(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryRecursivelyError(directory)
                pp error
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
                Ism.notifyOfFileReplaceTextError(filePath, text, newText)
                pp error
                exit 1
            end
        end

        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath)
                pp error
                exit 1
            end
            return content
        end

        def fileWriteData(filePath : String, data : String)
            begin
                File.write(filepath, data)
            rescue error
                Ism.notifyOfFileWriteDataError(filePath)
                pp error
                exit 1
            end
        end

        def fileAppendData(filePath : String, data : String)
            begin
                File.open(filePath,"a") do |file|
                    file.puts(data)
                end
            rescue error
                Ism.notifyOfFileAppendDataError(filePath)
                pp error
                exit 1
            end
        end 
        
        def makeSymbolicLink(path : String, targetPath : String)
            begin
                if File.symlink?(targetPath)
                    deleteFile(targetPath)
                end
                FileUtils.ln_sf(path, targetPath)
            rescue error
                Ism.notifyOfMakeSymbolicLinkError(path, targetPath)
                pp error
                exit 1
            end
        end

        def copyFile(path : String, targetPath : String)
            begin
                FileUtils.cp(path, targetPath)
            rescue error
                Ism.notifyOfCopyFileError(path, targetPath)
                pp error
                exit 1
            end
        end

        def copyDirectory(path : String, targetPath : String)
            begin
                FileUtils.cp_r(path, targetPath)
            rescue error
                Ism.notifyOfCopyDirectoryError(path, targetPath)
                pp error
                exit 1
            end
        end

        def deleteFile(path : String)
            begin
                File.delete(path)
            rescue error
                Ism.notifyOfDeleteFileError(path)
                pp error
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
                Ism.notifyOfDeleteAllHiddenFilesError(path)
                pp error
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
                Ism.notifyOfDeleteAllHiddenFilesRecursivelyError(path)
                pp error
                exit 1
            end
        end

        def runScript(file : String, path : String, arguments = Array(String).new)
            scriptCommand = "./#{file}"
            scriptCommand += arguments.join(" ")

            process = Process.run(  scriptCommand,
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: path)
            if !process.success?
                Ism.notifyOfRunScriptError(file, path)
                exit 1
            end
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments : Array(String), path = String.new, configureDirectory = String.new)
            if @buildDirectory
                configureCommand = "../#{configureDirectory}/configure "
            else
                configureCommand = "./#{configureDirectory}/configure "
            end

            configureCommand += arguments.join(" ")

            process = Process.run(  configureCommand,
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: path)
            if !process.success?
                Ism.notifyOfConfigureError(path)
                exit 1
            end
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makeSource(arguments : Array(String), path = String.new)
            process = Process.run("make",   args: arguments,
                                            output: :inherit,
                                            error: :inherit,
                                            chdir: path)
            if !process.success?
                Ism.notifyOfMakeError(path)
                exit 1
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def install
            Ism.notifyOfInstall(@information)

            filesList = Dir.glob("#{@information.builtSoftwareDirectoryPath}/**/*")

            filesList.each do |entry|
                finalDestination = entry.delete_at(1,@information.builtSoftwareDirectoryPath.size)
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
            deleteDirectoryRecursively(workDirectoryPath)
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
