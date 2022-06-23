module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceDirectoryName = String.new
        end

        def download
            Dir.mkdir(Ism.settings.sourcesPath+"/"+@information.versionName)
            Ism.notifyOfDownload(@information)
        end

        def downloadSource(link : String)
            process = Process.run("wget",   args: [link],
                                            output: :inherit,
                                            error: :inherit,
                                            chdir: Ism.settings.sourcesPath+"/"+@information.versionName)
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
        end

        def extractSource(archive : String)
            process = Process.run("tar",args: ["-xf", archive],
                                        chdir: Ism.settings.sourcesPath+"/"+@information.versionName)
            if !process.success?
                Ism.notifyOfExtractError(archive)
                exit 1
            end
        end
        
        def patch
            Ism.notifyOfPatch(@information)
        end
        
        def applyPatch(patch : String)
            process = Process.run("patch",  args: ["-Np1","-i",patch],
                                            chdir: Ism.settings.sourcesPath+"/"+@information.versionName+"/"+@mainSourceDirectoryName)
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                exit 1
            end
        end

        def mainWorkingDirectory : String
            return Ism.settings.sourcesPath+"/"+@information.versionName+"/"+@mainSourceDirectoryName
        end

        def prepare
            Ism.notifyOfPrepare(@information)
        end

        def moveFile(path : String, newPath : String)
            begin
                FileUtils.mv(   Ism.settings.sourcesPath + "/" + 
                                @information.versionName + "/" +
                                path,
                                Ism.settings.sourcesPath + "/" + 
                                @information.versionName + "/" +
                                newPath)
            rescue
                Ism.notifyOfMoveFileError(path, newPath)
                exit 1
            end
        end

        def makeDirectory(directory : String)
            begin
                Dir.mkdir(  Ism.settings.sourcesPath + "/" + 
                            @information.versionName + "/" +
                            directory)
            rescue
                Ism.notifyOfMakeDirectoryError(directory)
                exit 1
            end
        end

        def fileReplaceText(filePath : String, text : String, newText : String)
            begin
                content = File.read_lines(  Ism.settings.sourcesPath + "/" +
                                            @information.versionName + "/" +
                                            filePath)

                File.open(  Ism.settings.sourcesPath + "/" +
                            @information.versionName + "/" +
                            filePath,
                            "w") do |file|

                    content.each do |line|
                        if line.includes?(text)
                            file << line.gsub(text, newText)+"\n"
                        else
                            file << line+"\n"
                        end
                    end
                end
            rescue
                Ism.notifyOfFileReplaceTextError(   Ism.settings.sourcesPath + "/" +
                                                    @information.versionName + "/" +
                                                    filePath,
                                                    text,
                                                    newText)
                exit 1
            end
        end

        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue
                Ism.notifyOfGetFileContentError(filePath)
                exit 1
            end
            return content
        end

        def fileWriteData(filePath : String, data : String)
            begin
                File.write(filepath, data)
            rescue
                Ism.notifyOfFileWriteDataError(filePath)
                exit 1
            end
        end

        def fileAppendData(filePath : String, data : String)
            begin
                File.open(filePath,"a") do |file|
                    file.puts(data)
                end
            rescue
                Ism.notifyOfFileAppendDataError(filePath)
                exit 1
            end
        end 
        
        def makeSymbolicLink(path : String, targetPath : String)
            begin
                FileUtils.ln_sf(path, targetPath)
            rescue
                Ism.notifyOfMakeSymbolicLinkError(path, targetPath)
                exit 1
            end
        end

        def deleteFile(path : String)
            begin
                File.delete(path)
            rescue
                Ism.notifyOfDeleteFileError(path)
                exit 1
            end
        end

        def deleteAllHiddenFiles(path : String)
            begin
                (Dir.children(path+"/"+".").select {|f| File.file? f}).each do |file|
                    if file.starts_with?(".")
                        deleteFile(path+"/"+file)
                    end
                end
            rescue
                Ism.notifyOfDeleteAllHiddenFilesError(path)
                exit 1
            end
        end

        def deleteAllHiddenFilesRecursively(path : String)
            begin
                deleteAllHiddenFiles(path)

                (Dir.children(path+"/"+".").select {|f| File.directory? f}).each do |directory|
                    deleteAllHiddenFiles(directory)
                end
            rescue
                Ism.notifyOfDeleteAllHiddenFilesRecursivelyError(path)
                exit 1
            end
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments : Array(String), path = String.new, buildDirectory = false)
            if buildDirectory
                configureCommand = "../configure "
            else
                configureCommand = "./configure "
            end

            configureCommand += arguments.join(" ")

            process = Process.run(configureCommand, output: :inherit,
                                                    error: :inherit,
                                                    shell: true,
                                                    chdir:  Ism.settings.sourcesPath + "/" +
                                                            @information.versionName + "/" +
                                                            @mainSourceDirectoryName + "/" +
                                                            path)
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
                                            chdir:  Ism.settings.sourcesPath + "/" + 
                                                    @information.versionName + "/" +
                                                    @mainSourceDirectoryName + "/" +
                                                    path)
            if !process.success?
                Ism.notifyOfMakeError(path)
                exit 1
            end
        end
        
        def install
            Ism.notifyOfInstall(@information)
        end
        
        def clean
            Ism.notifyOfClean(@information)
            FileUtils.rm_r(Ism.settings.sourcesPath+"/"+@information.versionName)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
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
