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
            @buildDirectoryName = "build"
        end

        def getMainSourceDirectoryName
            result = String.new

            if !@information.downloadLinks.empty?
                result = @information.downloadLinks[0]
                result = result.lchop(result[0..result.rindex("/")])
                if result[-4..-1] == ".tgz" || result[-4..-1] == ".zip"
                    result = result[0..-5]+"/"
                end
                if result[-7..-1] == ".tar.gz" || result[-7..-1] == ".tar.xz"
                    result = result[0..-8]+"/"
                end
                if result.size > 7 && result[-8..-1] == ".tar.bz2"
                    result = result[0..-9]+"/"
                end
            end
            return result
        end

        def workDirectoryPath(relatedToChroot = true) : String
            return (relatedToChroot ? Ism.settings.installByChroot : false) ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.port+"/"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version
        end

        def mainWorkDirectoryPath(relatedToChroot = true) : String
            return workDirectoryPath(relatedToChroot)+"/"+@mainSourceDirectoryName
        end

        def buildDirectoryPath(relatedToChroot = true) : String
            return mainWorkDirectoryPath(relatedToChroot)+"/"+"#{@buildDirectory ? @buildDirectoryName : ""}"
        end

        def builtSoftwareDirectoryPath(relatedToChroot = true) : String
            return (relatedToChroot ? Ism.settings.installByChroot : false) ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"
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

            @information.options.each do |option|
                if option.active
                    option.downloadLinks.each do |link|
                        downloadSource(link)
                    end
                end
            end
        end

        def downloadSource(link : String)
            downloaded = false
            error = String.new

            until downloaded
                HTTP::Client.get(link) do |response|
                    if response.status.redirection?
                        begin
                            link = response.headers["location"]
                        rescue
                            error = "#{ISM::Default::Software::DownloadSourceRedirectionErrorText1}#{response.status_code}#{ISM::Default::Software::DownloadSourceRedirectionErrorText2}"

                            Ism.notifyOfDownloadError(link, error)
                            Ism.exitProgram
                        end
                        break
                    end

                    uri = URI.parse(link)
                    fileFullName = File.basename(uri.path)
                    fileExtension = File.extname(uri.path)
                    fileBaseName = File.basename(uri.path,fileExtension)
                    filePath = "#{workDirectoryPath(false)}/#{fileFullName}"
                    colorizedFileFullName = "#{fileBaseName}#{fileExtension.colorize(Colorize::ColorRGB.new(255,100,100))}"
                    colorizedLink = "#{link.colorize(:magenta)}"

                    lastSpeedUpdate = Time.monotonic
                    average = 0
                    bytesLastPeriod = 0

                    if response.status_code == 200
                        buffer = Bytes.new(65536)
                        totalRead = Int64.new(0)
                        lenght = response.headers["Content-Length"]? ? response.headers["Content-Length"].to_i32 : Int64.new(0)

                        File.open(filePath, "wb") do |data|
                            while (pos = response.body_io.read(buffer)) > 0
                                lapsed = Time.monotonic - lastSpeedUpdate

                                if lapsed.total_seconds >= 1
                                    div = lapsed.total_nanoseconds / 1_000_000_000
                                    average = (bytesLastPeriod / div).to_i32!
                                    bytesLastPeriod = 0
                                    lastSpeedUpdate = Time.monotonic
                                end

                                data.write(buffer[0...pos])
                                bytesLastPeriod += pos
                                totalRead += pos

                                if lenght > 0
                                    text = "\t#{colorizedFileFullName} [#{(Int64.new(totalRead*100/lenght).to_s+"%").colorize(:green)}] #{"{".colorize(:green)}#{average.humanize_bytes}/s#{"}".colorize(:green)} (#{colorizedLink})"
                                else
                                    text = "\t#{colorizedFileFullName} [#{"0%".colorize(:green)}] #{"{".colorize(:green)}#{average.humanize_bytes}/s#{"}".colorize(:green)} (#{colorizedLink})"
                                end

                                print text+"\r"
                            end
                        end

                        downloaded = true
                    else
                        error = "#{ISM::Default::Software::DownloadSourceCodeErrorText}#{response.status_code}"

                        Ism.notifyOfDownloadError(link, error)
                        Ism.exitProgram
                    end
                end
            end

            puts
        end
        
        def check
            Ism.notifyOfCheck(@information)

            @information.downloadLinks.each_with_index do |source, index|
                checkSource(workDirectoryPath(false)+"/"+source.lchop(source[0..source.rindex("/")]),@information.md5sums[index])
            end

            @information.options.each do |option|
                if option.active
                    option.downloadLinks.each_with_index do |source, index|
                        checkSource(workDirectoryPath(false)+"/"+source.lchop(source[0..source.rindex("/")]),option.md5sums[index])
                    end
                end
            end
        end

        def checkSource(archive : String, md5sum : String)
            digest = Digest::MD5.new
            digest.file(archive)
            archiveMd5sum = digest.hexfinal

            if archiveMd5sum != md5sum
                Ism.notifyOfCheckError(archive, md5sum)
                Ism.exitProgram
            end
        end
        
        def extract
            Ism.notifyOfExtract(@information)

            @information.downloadLinks.each do |source|
                sourceName = source.lchop(source[0..source.rindex("/")])

                if  sourceName[-4..-1] == ".tgz" ||
                    sourceName[-4..-1] == ".zip" ||
                    sourceName[-7..-1] == ".tar.gz" ||
                    sourceName[-7..-1] == ".tar.xz" ||
                    sourceName.size > 7 && sourceName[-8..-1] == ".tar.bz2"

                    extractSource(source.lchop(source[0..source.rindex("/")]))
                end
            end

            @information.options.each do |option|
                if option.active
                    option.downloadLinks.each do |source|
                        sourceName = source.lchop(source[0..source.rindex("/")])

                        if  sourceName[-4..-1] == ".tgz" ||
                            sourceName[-4..-1] == ".zip" ||
                            sourceName[-7..-1] == ".tar.gz" ||
                            sourceName[-7..-1] == ".tar.xz" ||
                            sourceName.size > 7 && sourceName[-8..-1] == ".tar.bz2"

                            extractSource(source.lchop(source[0..source.rindex("/")]))
                        end
                    end
                end
            end
        end

        def extractSource(archive : String)
            if archive[-4..-1] == ".zip"
                extractedDirectory = archive[0..-5]

                makeDirectory("#{workDirectoryPath(false)}/#{extractedDirectory}")
                moveFile("#{workDirectoryPath(false)}/#{archive}","#{workDirectoryPath(false)}/#{extractedDirectory}/#{archive}")

                process = Process.run("unzip",args: [archive],
                                            error: :inherit,
                                            chdir: workDirectoryPath(false)+"/"+extractedDirectory)
            else
                process = Process.run("tar",args: [ "-xf",
                                                    archive],
                                            error: :inherit,
                                            chdir: workDirectoryPath(false))
            end
            if !process.success?
                Ism.notifyOfExtractError(archive)
                Ism.exitProgram
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
                Ism.exitProgram
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
                Ism.exitProgram
            end
        end

        def moveFile(path : String | Enumerable(String), newPath : String)
            begin
                FileUtils.mv(path, newPath)
            rescue error
                Ism.notifyOfMoveFileError(path, newPath, error)
                Ism.exitProgram
            end
        end

        def makeDirectory(directory : String)
            begin
                FileUtils.mkdir_p(directory)
            rescue error
                Ism.notifyOfMakeDirectoryError(directory, error)
                Ism.exitProgram
            end
        end

        def deleteDirectory(directory : String)
            begin
                Dir.delete(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryError(directory, error)
                Ism.exitProgram
            end
        end

        def deleteDirectoryRecursively(directory : String)
            begin
                FileUtils.rm_r(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryRecursivelyError(directory, error)
                Ism.exitProgram
            end
        end

        def setPermissions(path : String, permissions : Int)
            begin
                File.chmod(path,permissions)
            rescue error
                Ism.notifyOfSetPermissionsError(path, permissions, error)
                Ism.exitProgram
            end
        end

        def setOwner(path : String, uid : Int | String, gid : Int | String)
            begin
                File.chown( path,
                            (uid.is_a?(String) ? System::Group.find_by(name: uid).id : uid).to_i,
                            (gid.is_a?(String) ? System::Group.find_by(name: gid).id : gid).to_i)
            rescue error
                Ism.notifyOfSetOwnerError(path, uid, gid, error)
                Ism.exitProgram
            end
        end

        def setPermissionsRecursively(path : String, permissions : Int)
            begin
                Dir.glob("#{path}/**/*") do |file_path|
                    setPermissions(path, permissions)
                end
            rescue error
                Ism.notifyOfSetPermissionsRecursivelyError(path, permissions, error)
                Ism.exitProgram
            end
        end

        def setOwnerRecursively(path : String, uid : Int | String, gid : Int | String)
            begin
                Dir.glob("#{path}/**/*") do |file_path|
                    setOwner(path, uid, gid)
                end
            rescue error
                Ism.notifyOfSetOwnerRecursivelyError(path, uid, gid, error)
                Ism.exitProgram
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
                Ism.exitProgram
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
                Ism.exitProgram
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
                Ism.exitProgram
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
                Ism.exitProgram
            end
        end

        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath, error)
                Ism.exitProgram
            end
            return content
        end

        def fileWriteData(filePath : String, data : String)
            begin
                File.write(filePath, data)
            rescue error
                Ism.notifyOfFileWriteDataError(filePath, error)
                Ism.exitProgram
            end
        end

        def fileAppendData(filePath : String, data : String)
            begin
                File.open(filePath,"a") do |file|
                    file.puts(data)
                end
            rescue error
                Ism.notifyOfFileAppendDataError(filePath, error)
                Ism.exitProgram
            end
        end 

        def fileUpdateContent(filePath : String, data : String)
            begin
                content = getFileContent(filePath)
                if !content.includes?(data)
                    fileAppendData(filePath,"\n"+data)
                end
            rescue error
                Ism.notifyOfFileUpdateContentError(filePath, error)
                Ism.exitProgram
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
                    Ism.exitProgram
                end
            rescue File::AlreadyExistsError

            rescue error
                Ism.notifyOfMakeSymbolicLinkError(path, targetPath, error)
                Ism.exitProgram
            end
        end

        def copyFile(path : String | Enumerable(String), targetPath : String)
            begin
                FileUtils.cp(path, targetPath)
            rescue error
                Ism.notifyOfCopyFileError(path, targetPath, error)
                Ism.exitProgram
            end
        end

        def copyDirectory(path : String, targetPath : String)
            begin
                FileUtils.cp_r(path, targetPath)
            rescue error
                Ism.notifyOfCopyDirectoryError(path, targetPath, error)
                Ism.exitProgram
            end
        end

        def deleteFile(path : String | Enumerable(String))
            begin
                FileUtils.rm(path)
            rescue error
                Ism.notifyOfDeleteFileError(path, error)
                Ism.exitProgram
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
                Ism.exitProgram
            end
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            begin
                Dir.glob("#{path}/**/*") do |file_path|
                    if File.file?(file_path) && file_path == "#{path}/#{filename}".squeeze("/")
                        fileReplaceText(file_path, text, newText)
                    end
                end
            rescue error
                Ism.notifyOfReplaceTextAllFilesRecursivelyNamedError(path, filename, text, newText, error)
                Ism.exitProgram
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
                Ism.exitProgram
            end
        end

        def deleteAllFilesRecursivelyFinishing(path : String, text : String)
            begin
                Dir.glob("#{path}/**/*") do |file_path|
                    if File.file?(file_path) && file_path[-text.size..-1] == text
                        deleteFile(file_path)
                    end
                end
            rescue error
                Ism.notifyOfDeleteAllFilesRecursivelyFinishingError(path, text, error)
                Ism.exitProgram
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
                Ism.exitProgram
            end
        end

        def deleteAllHiddenFilesRecursively(path : String)
            begin
                Dir.glob("#{path}/**/.*", match_hidden: true) do |file_path|
                    if File.file?(file_path)
                        deleteFile(file_path)
                    end
                end
            rescue error
                Ism.notifyOfDeleteAllHiddenFilesRecursivelyError(path, error)
                Ism.exitProgram
            end
        end

        def runChrootTasks(chrootTasks) : Process::Status
            File.write(Ism.settings.rootPath+ISM::Default::Filename::Task, chrootTasks)

            process = Process.run("chmod",  args: [ "+x",
                                                    "#{Ism.settings.rootPath}#{ISM::Default::Filename::Task}"],
                                            output: :inherit,
                                            error: :inherit,
                                            shell: true)

            process = Process.run("chroot",   args: [ Ism.settings.rootPath,
                                                    "./#{ISM::Default::Filename::Task}"],
                                            output: :inherit,
                                            error: :inherit,
                                            shell: true)

            File.delete(Ism.settings.rootPath+ISM::Default::Filename::Task)

            return process
        end

        def runSystemCommand(arguments = Array(String).new, path = Ism.settings.installByChroot ? "/" : Ism.settings.rootPath, environment = Hash(String, String).new) : Process::Status
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootCommand)
            else
                process = Process.run(  arguments[0],
                                        args: arguments[1..arguments.size-1],
                                        output: Process::Redirect::Inherit,
                                        error: Process::Redirect::Inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end

            return process
        end

        def runChmodCommand(arguments = Array(String).new, path = String.new)
            requestedCommands = ["chmod"]+arguments

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runUserAddCommand(arguments : Array(String))
            requestedCommands = ["useradd"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGroupAddCommand(arguments : Array(String))
            requestedCommands = ["groupadd"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runScript(file : String, arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = ["./#{file}"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runPythonCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = ["python"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runCrystalCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = ["crystal"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runCmakeCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = ["cmake"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runMesonCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = ["meson"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runNinjaCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                arguments.unshift(makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions)
            else
                arguments.unshift(makeOptions == "" ? Ism.settings.makeOptions : makeOptions)
            end

            requestedCommands = ["ninja"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runPwconvCommand(arguments = Array(String).new)
            requestedCommands = ["pwconv"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGrpconvCommand(arguments = Array(String).new)
            requestedCommands = ["grpconv"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUdevadmCommand(arguments : Array(String))
            requestedCommands = ["udevadm"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runDbusUuidgenCommand(arguments = Array(String).new)
            requestedCommands = ["dbus-uuidgen"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runMakeinfoCommand(arguments : Array(String), path = String.new)
            requestedCommands = ["makeinfo"]+arguments

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runInstallInfoCommand(arguments : Array(String))
            requestedCommands = ["install-info"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runAutoreconfCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = ["autoreconf"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runLocaledefCommand(arguments : Array(String))
            requestedCommands = ["localedef"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGunzipCommand(arguments : Array(String), path = String.new)
            requestedCommands = ["gunzip"]+arguments

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runMakeCaCommand(arguments : Array(String))
            requestedCommands = ["make-ca"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runInstallCatalogCommand(arguments : Array(String))
            requestedCommands = ["install-catalog"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runXmlCatalogCommand(arguments : Array(String))
            requestedCommands = ["xmlcatalog"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runLdconfigCommand(arguments = Array(String).new)
            requestedCommands = ["ldconfig"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def sourceFile(arguments = Array(String).new)
            requestedCommands = ["source"]+arguments

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(arguments)
                Ism.exitProgram
            end
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments = Array(String).new, path = String.new, configureDirectory = String.new, environment = Hash(String, String).new)
            if @buildDirectory
                configureCommand = "../#{configureDirectory}/configure"
            else
                configureCommand = "./#{configureDirectory}/configure"
            end

            requestedCommands = [configureCommand]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makePerlSource(path = String.new)
            requestedCommands = ["perl","Makefile.PL"]

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def makeSource(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                arguments.unshift(makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions)
            else
                arguments.unshift(makeOptions == "" ? Ism.settings.makeOptions : makeOptions)
            end

            requestedCommands = ["make"]+arguments

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def install
            Ism.notifyOfInstall(@information)

            filesList = Dir.glob("#{builtSoftwareDirectoryPath(false)}/**/*", match_hidden: true)
            installedFiles = Array(String).new

            filesList.each do |entry|
                finalDestination = entry.delete_at(1,builtSoftwareDirectoryPath(false).size+Ism.settings.rootPath.size-2)

                if File.directory?(entry)
                    if !Dir.exists?(Ism.settings.rootPath+finalDestination)
                        makeDirectory(Ism.settings.rootPath+finalDestination)
                    end
                else
                    moveFile(entry,Ism.settings.rootPath+finalDestination)
                    installedFiles << finalDestination
                end

            end

            Ism.addInstalledSoftware(@information, installedFiles)
        end
        
        def clean
            Ism.notifyOfClean(@information)
            deleteDirectoryRecursively(workDirectoryPath(false))
        end

        def showInformations
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
            information.installedFiles.each do |file|
                deleteFile(Ism.settings.rootPath+file)
            end
        end

        def option(optionName : String) : Bool
            return @information.option(optionName)
        end

        def architecture(architecture : String) : Bool
            return Ism.settings.architecture == architecture
        end

        def showInfo(message : String)
            Ism.printInformationNotification(message)
        end

        def showInfoCode(message : String)
            Ism.printInformationCodeNotification(message)
        end

    end

end
