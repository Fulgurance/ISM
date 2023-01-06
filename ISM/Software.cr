module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String
        property buildDirectory : Bool
        property useChroot : Bool

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceDirectoryName = getMainSourceDirectoryName
            @buildDirectory = false
            @useChroot = false
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
            return @useChroot ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+"/"+@information.name+"/"+@information.version
        end

        def mainWorkDirectoryPath : String
            return workDirectoryPath+"/"+@mainSourceDirectoryName
        end

        def buildDirectoryPath : String
            return mainWorkDirectoryPath+"/"+"#{@buildDirectory ? "/build" : ""}"
        end

        def builtSoftwareDirectoryPath : String
            return @useChroot ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}/#{@information.builtSoftwareDirectoryPath}"
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
            @information.downloadLinks.each_with_index do |source, index|
                checkSource(workDirectoryPath+"/"+source.lchop(source[0..source.rindex("/")]),@information.md5sums[index])
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
            process = Process.run("tar",args: ["-xf", archive],
                                        error: :inherit,
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
                                            error: :inherit,
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

        def copyFile(path : String, targetPath : String)
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

        def runScript(file : String, path : String, arguments = Array(String).new)
            scriptCommand = "./#{file}"

            process = Process.run(  scriptCommand,
                                    args: arguments,
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true,
                                    chdir: path)
            if !process.success?
                Ism.notifyOfRunScriptError(file, path)
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

            if @useChroot
                chrootConfigureCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{configureCommand}
                CODE

                process = runChrootTasks(chrootConfigureCommand)
            else
                process = Process.run(  configureCommand,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path)
            end

            if !process.success?
                Ism.notifyOfConfigureError(path)
                exit 1
            end
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makeSource(arguments : Array(String), path = String.new)
            if @useChroot
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
                Ism.notifyOfMakeError(path)
                exit 1
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def install
            Ism.notifyOfInstall(@information)

            filesList = Dir.glob("#{builtSoftwareDirectoryPath}/**/*")

            filesList.each do |entry|
                finalDestination = entry.delete_at(1,builtSoftwareDirectoryPath.size)
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
