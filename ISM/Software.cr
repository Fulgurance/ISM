module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String
        property buildDirectory : Bool
        property buildDirectoryNames : Hash(String,String)

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.new
            @information.loadInformationFile(informationPath)
            @mainSourceDirectoryName = ISM::Default::Software::SourcesDirectoryName
            @buildDirectory = false
            @buildDirectoryNames = { ISM::Default::Software::MainBuildDirectoryEntry => "mainBuild" }
        end

        #Special function to improve performance (Internal use only)
        def workDirectoryPathNoChroot : String
            return Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version
        end

        #Special function to improve performance (Internal use only)
        def mainWorkDirectoryPath : String
            return workDirectoryPathNoChroot+"/"+@mainSourceDirectoryName
        end

        #Special function to improve performance (Internal use only)
        def buildDirectoryPathNoChroot(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPathNoChroot+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"
        end

        #Special function to improve performance (Internal use only)
        def builtSoftwareDirectoryPathNoChroot : String
            return "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"
        end

        def workDirectoryPath : String
            return Ism.settings.installByChroot ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.port+"/"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version
        end

        def mainWorkDirectoryPath : String
            return workDirectoryPath+"/"+@mainSourceDirectoryName
        end

        def buildDirectoryPath(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPath+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"
        end

        def builtSoftwareDirectoryPath : String
            return Ism.settings.installByChroot ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"
        end

        def mainKernelName : String
            @information.uniqueDependencies.each do |uniqueDependency|
                uniqueDependency.each do |entry|

                    if @information.uniqueDependencyIsEnabled(entry)

                        @information.dependencies(allowDeepSearch: true).each do |dependency|
                            if dependency.fullName.downcase == entry.downcase
                                return dependency.versionName.downcase
                            end
                        end
                    end
                end
            end

            #Exit and show a message that no kernel are selected ?
            return String.new
        end

        def prepareKernelSourcesInstallation
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/src/")
            moveFile("#{workDirectoryPath}/Sources","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/src/#{@information.versionName.downcase}")
        end

        def download
            Ism.notifyOfDownload(@information)

            cleanWorkDirectoryPath

            downloadSources
            downloadSourcesMd5sum

            if remoteFileIsAvailable(@information.patchesLink)
                downloadPatches
                downloadPatchesMd5sum
            end
        end

        def downloadSources
            downloadFile(   @information.sourcesLink,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveExtensionName)
        end

        def downloadSourcesMd5sum
            downloadFile(   @information.sourcesMd5sumLink,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveMd5sumExtensionName)
        end

        def remoteFileIsAvailable(fileUrl : String) : Bool
            response = HTTP::Client.get(fileUrl)

            return response.status == HTTP::Status::OK
        end

        def downloadPatches
            downloadFile(   @information.patchesLink,
                                ISM::Default::Software::PatchesArchiveBaseName,
                                ISM::Default::Software::ArchiveExtensionName)
        end

        def downloadPatchesMd5sum
            downloadFile(   @information.patchesMd5sumLink,
                            ISM::Default::Software::PatchesArchiveBaseName,
                            ISM::Default::Software::ArchiveMd5sumExtensionName)
        end

        def downloadFile(link : String, filename : String, fileExtensionName : String)
            originalLink = link
            downloaded = false
            error = String.new

            #ACTUALLY BRING DOWNLOAD FAILURE
            #Checking if connexion is available
            # begin
            #     TCPSocket.new(link, port: 80, connect_timeout: 500.milliseconds).close
            # rescue ex : IO::Error
            #     Ism.notifyOfConnexionError(link)
            #     Ism.exitProgram
            # end

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

                    filePath = "#{workDirectoryPath}/#{filename+fileExtensionName}"
                    colorizedFileFullName = "#{filename}#{fileExtensionName.colorize(Colorize::ColorRGB.new(255,100,100))}"
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
                                    text = "\t#{"| ".colorize(:green)} #{colorizedFileFullName} [#{(Int64.new(totalRead*100/lenght).to_s+"%").colorize(:green)}] #{"{".colorize(:green)}#{average.humanize_bytes}/s#{"}".colorize(:green)} (#{colorizedLink})"
                                else
                                    text = "\t#{"| ".colorize(:green)} #{colorizedFileFullName} [#{"0%".colorize(:green)}] #{"{".colorize(:green)}#{average.humanize_bytes}/s#{"}".colorize(:green)} (#{colorizedLink})"
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
        
        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath, error)
                Ism.exitProgram
            end
            return content
        end

        def check
            Ism.notifyOfCheck(@information)
            checkSourcesMd5sum
            if File.exists?(workDirectoryPath+"/"+ISM::Default::Software::PatchesMd5sumArchiveName)
                checkPatchesMd5sum
            end
        end

        def checkSourcesMd5sum
            checkFile(  workDirectoryPath+"/"+ISM::Default::Software::SourcesArchiveName,
                        getFileContent(workDirectoryPath+"/"+ISM::Default::Software::SourcesMd5sumArchiveName).strip)
        end

        def checkPatchesMd5sum
            checkFile(  workDirectoryPath+"/"+ISM::Default::Software::PatchesArchiveName,
                        getFileContent(workDirectoryPath+"/"+ISM::Default::Software::PatchesMd5sumArchiveName).strip)
        end

        def checkFile(archive : String, md5sum : String)
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
            extractSources
            if File.exists?(workDirectoryPath+"/"+ISM::Default::Software::PatchesMd5sumArchiveName)
                extractPatches
            end
        end

        def extractSources
            extractArchive(workDirectoryPath+"/"+ISM::Default::Software::SourcesArchiveName, workDirectoryPath)
            moveFile(workDirectoryPath+"/"+@information.versionName,workDirectoryPath+"/"+ISM::Default::Software::SourcesDirectoryName)
        end

        def extractPatches
            extractArchive(workDirectoryPath+"/"+ISM::Default::Software::PatchesArchiveName, workDirectoryPath)
            moveFile(workDirectoryPath+"/"+@information.versionName,workDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName)
        end

        def extractArchive(archivePath : String, destinationPath = workDirectoryPath)

            process = Process.run(  "tar -xf #{archivePath}",
                                    error: :inherit,
                                    shell: true,
                                    chdir: destinationPath)
            if !process.success?
                Ism.notifyOfExtractError(archivePath, destinationPath)
                Ism.exitProgram
            end
        end
        
        def patch
            Ism.notifyOfPatch(@information)

            if Dir.exists?("#{workDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName}")
                Dir["#{workDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName}/*"].each do |patch|
                    applyPatch(patch)
                end
            end

            if Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{@information.versionName}")
                Dir[Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{@information.versionName}/*"].each do |patch|
                    patchName = patch.lchop(patch[0..patch.rindex("/")])
                    Ism.notifyOfLocalPatch(patchName)
                    applyPatch(patch)
                end
            end
        end
        
        def applyPatch(patch : String)
            process = Process.run(  "patch -Np1 -i #{patch}",
                                    error: :inherit,
                                    shell: true,
                                    chdir: mainWorkDirectoryPath)
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                Ism.exitProgram
            end
        end

        def prepare
            Ism.notifyOfPrepare(@information)

            #Generate all build directories
            @buildDirectoryNames.keys.each do |key|
                if !Dir.exists?(buildDirectoryPath(key))
                    makeDirectory(buildDirectoryPath(key))
                end
            end
        end

        #Special function to improve performance (Internal use only)
        def copyDirectoryNoChroot(path : String, targetPath : String)
            begin
                FileUtils.cp_r(path, targetPath)
            rescue error
                Ism.notifyOfCopyDirectoryError(path, targetPath, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def deleteFileNoChroot(path : String)
            begin
                FileUtils.rm(path)
            rescue error
                Ism.notifyOfDeleteFileError(path, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def moveFileNoChroot(path : String, newPath : String)
            begin
                FileUtils.mv(path, newPath)
            rescue error
                Ism.notifyOfMoveFileError(path, newPath, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def makeDirectoryNoChroot(directory : String)
            begin
                FileUtils.mkdir_p(directory)
            rescue error
                Ism.notifyOfMakeDirectoryError(directory, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def deleteDirectoryNoChroot(directory : String)
            begin
                FileUtils.rm_r(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryError(directory, error)
                Ism.exitProgram
            end
        end

        # def fileUpdateContent(filePath : String, data : String)
        #     begin
        #         content = getFileContent(filePath)
        #         if !content.includes?(data)
        #             fileAppendData(filePath,"\n"+data)
        #         end
        #     rescue error
        #         Ism.notifyOfFileUpdateContentError(filePath, error)
        #         Ism.exitProgram
        #     end
        # end

        def runChrootTasks(chrootTasks) : Process::Status
            File.write(Ism.settings.rootPath+ISM::Default::Filename::Task, chrootTasks)

            process = Process.run(  "chmod +x #{Ism.settings.rootPath}#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true)

            process = Process.run(  "chroot #{Ism.settings.rootPath} ./#{ISM::Default::Filename::Task}",
                                    output: :inherit,
                                    error: :inherit,
                                    shell: true)

            File.delete(Ism.settings.rootPath+ISM::Default::Filename::Task)

            return process
        end

        def runSystemCommand(command : String, path = Ism.settings.installByChroot ? "/" : Ism.settings.rootPath, environment = Hash(String, String).new) : Process::Status
            environmentCommand = String.new

            environment.keys.each do |key|
                environmentCommand += " #{key}=\"#{environment[key]}\""
            end

            Ism.recordSystemCall(command, path, environment)

            if Ism.settings.installByChroot
                chrootCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{command}
                CODE

                process = runChrootTasks(chrootCommand)
            else
                process = Process.run(  command,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: (path == "" ? nil : path),
                                        env: environment)
            end

            return process
        end

        def fileReplaceText(path : String, text : String, newText : String)
            requestedCommands = <<-CMD
                                sed -i 's/#{text.gsub("/","\\/")}/#{newText.gsub("/","\\/")}/g' #{path}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceLineContaining(path : String, text : String, newLine : String)
            requestedCommands = <<-CMD
                                sed -i '/#{text.gsub("/","\\/")}/c\#{newText.gsub("/","\\/")}' #{path}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceTextAtLineNumber(path : String, text : String, newText : String,lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}s/#{text.gsub("/","\\/")}/#{newText.gsub("/","\\/")}' #{path}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileDeleteLine(path : String, lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}d' #{path}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileWriteData(path : String, data : String)
            requestedCommands = <<-CMD
                                cat > #{path} <<EOF
                                #{data}
                                EOF
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileAppendData(path : String, data : String)
            requestedCommands = <<-CMD
                                echo -i "#{data}" > "#{path}"
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileAppendDataFromFile(path : String, targetPath : String)
            requestedCommands = <<-CMD
                                cat #{path} >> #{targetPath}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            requestedCommands = <<-CMD
                                find man -name #{filename} -exec sed -i 's/#{text.gsub("/","\\/")}/#{newText.gsub("/","\\/")}/'   {} \;
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def deleteAllFilesRecursivelyFinishing(path : String, extensions = Array(String).new)
            extensionCommands = Array(String).new

            extensions.each do |extension|
                extensionCommands.push("-o")
                extensionCommands.push("-name")
                extensionCommands.push("\\*.#{extension} \\")
            end

            requestedCommands = <<-CMD
                                find doc \( -name #{path} #{extensionCommands} ) -exec rm -v {} \;
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def makeLink(target : String, path : String, type : Symbol)
            command = String.new

            case type
            when :hardLink
                command = "ln"
            when :symbolicLink
                command = "ln -s"
            when :symbolicLinkByOverwrite
                command = "ln -sf"
            else
                Ism.notifyOfMakeLinkUnknowTypeError(target, path, type)
                Ism.exitProgram
            end

            requestedCommands = "#{command} #{target} #{path}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def generateEmptyFile(path : String)
            requestedCommands = "touch #{path}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def copyFile(path : String, targetPath : String)
            requestedCommands = "cp #{path} #{targetPath}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def copyDirectory(path : String, targetPath : String)
            requestedCommands = "cp -r #{path} #{targetPath}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def moveFile(path : String, newPath : String)
            requestedCommands = "mv #{path} #{newPath}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def makeDirectory(path : String)
            requestedCommands = "mkdir -p #{path}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def deleteDirectory(path : String)
            requestedCommands = "rm -r #{path}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def deleteFile(path : String)
            requestedCommands = "rm #{path}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runChmodCommand(arguments = String.new, path = String.new)
            requestedCommands = "chmod #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runChownCommand(arguments = String.new, path = String.new)
            requestedCommands = "chown #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runUserAddCommand(arguments : String)
            prefix = option("Pass1") ? "-R #{Ism.settings.rootPath} " : String.new

            requestedCommands = "useradd #{prefix.empty? ? arguments : prefix+arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUserDelCommand(arguments : String)
            prefix = option("Pass1") ? "-R #{Ism.settings.rootPath} " : String.new

            requestedCommands = "userdel #{prefix.empty? ? arguments : prefix+arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGroupAddCommand(arguments : String)
            prefix = option("Pass1") ? "-R #{Ism.settings.rootPath} " : String.new

            requestedCommands = "groupadd #{prefix.empty? ? arguments : prefix+arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGroupDelCommand(arguments : String)
            prefix = option("Pass1") ? "-R #{Ism.settings.rootPath} " : String.new

            requestedCommands = "groupdel #{prefix.empty? ? arguments : prefix+arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runFile(file : String, arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "./#{file} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runPythonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "python #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runCrystalCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "crystal #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runCmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "cmake #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runMesonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "meson #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runNinjaCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                prefix = (makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions)
            else
                prefix = (makeOptions == "" ? Ism.settings.makeOptions : makeOptions)
            end

            requestedCommands = "ninja #{prefix} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runPwconvCommand(arguments = String.new)
            requestedCommands = "pwconv #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGrpconvCommand(arguments = String.new)
            requestedCommands = "grpconv #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUdevadmCommand(arguments : String)
            requestedCommands = "udevadm #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runDbusUuidgenCommand(arguments = String.new)
            requestedCommands = "dbus-uuidgen #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runMakeinfoCommand(arguments : String, path = String.new)
            requestedCommands = "makeinfo #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runInstallInfoCommand(arguments : String)
            requestedCommands = "install-info #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runAutoconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "autoconf #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runAutoreconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "autoreconf #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runLocaledefCommand(arguments : String)
            requestedCommands = "localedef #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGunzipCommand(arguments : String, path = String.new)
            requestedCommands = "gunzip #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runMakeCaCommand(arguments : String)
            requestedCommands = "make-ca #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runInstallCatalogCommand(arguments : String)
            requestedCommands = "install-catalog #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runXmlCatalogCommand(arguments : String)
            requestedCommands = "xmlcatalog #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runLdconfigCommand(arguments = String.new)
            requestedCommands = "ldconfig #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGtkQueryImmodules2Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-2.0 #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGtkQueryImmodules3Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-3.0 #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGlibCompileSchemasCommand(arguments = String.new)
            requestedCommands = "glib-compile-schemas #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGdkPixbufQueryLoadersCommand(arguments = String.new)
            requestedCommands = "gdk-pixbuf-query-loaders #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUpdateMimeDatabaseCommand(arguments = String.new)
            requestedCommands = "update-mime-database #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def sourceFile(arguments = String.new)
            requestedCommands = "source #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runCargoCommand(arguments : String, path = String.new)
            requestedCommands = "cargo #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runGccCommand(arguments = String.new, path = String.new)
            requestedCommands = "gcc #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runRcUpdateCommand(arguments = String.new)
            requestedCommands = "rc-update #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runAlsactlCommand(arguments = String.new)
            requestedCommands = "alsactl #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGtkUpdateIconCacheCommand(arguments = String.new)
            requestedCommands = "gtk-update-icon-cache #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUpdateDesktopDatabaseCommand(arguments = String.new)
            requestedCommands = "update-desktop-database #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runZicCommand(arguments : String, path = String.new)
            requestedCommands = "zic #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def prepareOpenrcServiceInstallation(path : String, name : String)
            servicesPath = "/etc/init.d/"

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")
            moveFile(path,"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}#{name}")
            runChmodCommand("+x #{name}","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments = String.new, path = String.new, configureDirectory = String.new, environment = Hash(String, String).new, relatedToMainBuild = true)
            configureCommand = "#{@buildDirectory && relatedToMainBuild ? ".." : "."}/#{configureDirectory}/configure"

            requestedCommands = "#{configureCommand} #{arguments}"

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
            requestedCommands = "perl Makefile.PL"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runCpanCommand(arguments = String.new)
            requestedCommands = "cpan #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(arguments)
                Ism.exitProgram
            end
        end

        def makeSource(arguments = String.new, path = String.new, environment = Hash(String, String).new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                prefix = (makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions)
            else
                prefix = (makeOptions == "" ? Ism.settings.systemMakeOptions : makeOptions)
            end

            requestedCommands = "make #{prefix} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def recordInstallationInformation : Tuple(UInt128, UInt128, UInt128, UInt128)
            directoryNumber = UInt128.new(0)
            symlinkNumber = UInt128.new(0)
            fileNumber = UInt128.new(0)
            totalSize = UInt128.new(0)

            filesList = Dir.glob(["#{builtSoftwareDirectoryPath}/**/*"], match: :dot_files)

            directoryNumber = UInt128.new(0)
            symlinkNumber = UInt128.new(0)
            fileNumber = UInt128.new(0)
            totalSize = UInt128.new(0)

            filesList.each do |entry|

                finalDestination = "/#{entry.sub(builtSoftwareDirectoryPath,"")}"

                if File.directory?(entry)
                    if !Dir.exists?(finalDestination)
                        directoryNumber += 1
                    end
                else
                    if File.symlink?(entry)
                        symlinkNumber += 1
                    else
                        fileNumber += 1
                        totalSize += File.size(entry)
                    end
                end

            end

            return directoryNumber, symlinkNumber, fileNumber, totalSize
        end

        def install
            Ism.notifyOfInstall(@information)

            filesList = Dir.glob(["#{builtSoftwareDirectoryPathNoChroot}/**/*"], match: :dot_files)
            installedFiles = Array(String).new

            filesList.each do |entry|

                finalDestination = "/#{entry.sub(builtSoftwareDirectoryPathNoChroot,"")}"

                if File.directory?(entry)
                    if !Dir.exists?(finalDestination)
                        makeDirectoryNoChroot(finalDestination)
                        installedFiles << "/#{finalDestination.sub(Ism.settings.rootPath,"")}".squeeze("/")
                    end
                else
                    #Delete existing file instead of overriding it to avoid any crash
                    if File.exists?(finalDestination)
                        deleteFileNoChroot(finalDestination)
                    end

                    moveFileNoChroot(entry,finalDestination)
                    installedFiles << "/#{finalDestination.sub(Ism.settings.rootPath,"")}".squeeze("/")
                end

            end

            Ism.addInstalledSoftware(@information, installedFiles)
        end

        def kernelName : String
            return "#{@information.versionName.downcase}"
        end

        def kernelSourcesPath : String
            return "#{Ism.settings.rootPath}usr/src/#{kernelName}/"
        end

        def kernelSourcesArchitecturePath : String
            return "#{kernelSourcesPath}arch/"
        end

        def kernelKconfigFilePath : String
            return "#{kernelSourcesPath}Kconfig"
        end

        def kernelArchitectureKconfigFilePath : String
            return "#{kernelSourcesArchitecturePath}Kconfig"
        end

        def kernelConfigFilePath : String
            return "#{kernelSourcesPath}.config"
        end

        def kernelOptionsDatabasePath : String
            return Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+kernelName
        end

        def setKernelOption(symbol : String, state : Symbol, value = String.new)
            case state
            when :enable
                arguments = ["-e","#{symbol}"]
            when :disable
                arguments = ["-d","#{symbol}"]
            when :module
                arguments = ["-m","#{symbol}"]
            when :string
                arguments = ["--set-str","#{symbol}",value]
            when :value
                arguments = ["--set-val","#{symbol}",value]
            end

            runScript("#{kernelSourcesPath}config",arguments,"#{kernelSourcesPath}scripts")
        end

        #Return an array splitted, except when there are conditions between parenthesis
        def getConditionArray(conditions : String) : Array(String)
            parenthesisArray = conditions.scan(/(!?\(.*?\))/)

            parenthesisArray.each do |old|
                new = old.to_s.gsub(" && ","&&")
                new = new.gsub(" || ","||")

                conditions = conditions.gsub(old.to_s,new)
            end

            return conditions.split(" && ")
        end

        def parseKconfigConditions(conditions : String)
            conditionArray = getConditionArray(conditions)

            dependencies = Array(String).new
            singleChoiceDependencies = Array(Array(String)).new
            blockers = Array(String).new

            conditionArray.each_with_index do |word, index|

                parenthesis = word.includes?("(")

                if parenthesis

                    reverseCondition = word.starts_with?("!")


                else
                    if word.starts_with?("!")
                        blockers.push(word)
                    else
                        dependencies.push(word)
                    end
                end

            end

            return dependencies,singleChoiceDependencies,blockers
        end

        def getFullKernelKconfigFile(kconfigPath : String) : Array(String)
            content = File.read_lines(kernelKconfigFilePath)

            result = content.dup
            nextResult = result.dup

            loop do

                if !result.any? {|line| line.starts_with?(ISM::Default::Software::KconfigKeywords[:source])}
                    break
                end

                nextResult.clear

                result.each do |line|

                    if line.starts_with?(ISM::Default::Software::KconfigKeywords[:source]) && !line.includes?("Kconfig.include")

                        mainArchitecture = (Ism.settings.installByChroot ? Ism.settings.chrootArchitecture : Ism.settings.architecture).gsub(/_.*/,"")

                        path = kernelSourcesPath+line
                        path = path.gsub(ISM::Default::Software::KconfigKeywords[:source],"")
                        path = path.gsub("\"","")
                        path = path.gsub("$(SRCARCH)","#{mainArchitecture}")
                        path = path.gsub("$(HEADER_ARCH)","#{mainArchitecture}")

                        begin
                            temp = File.read_lines(path)
                            nextResult += temp
                        rescue
                            nextResult += Array(String).new
                        end

                    elsif line.starts_with?(ISM::Default::Software::KconfigKeywords[:source]) && line.includes?("Kconfig.include")
                        nextResult += Array(String).new
                    else
                        nextResult.push(line)
                    end
                end

                result = nextResult.dup

            end

            return result
        end

        def generateKernelOptionsFiles(kconfigContent : Array(String))
            kernelOption = ISM::KernelOption.new
            kernelOptions = Array(ISM::KernelOption).new

            lastIfIndex = 0
            lastEndIfIndex = 0
            lastMenuConfigIndex =  0
            lastIfContent = String.new
            lastMenuConfigContent = String.new

            kconfigContent.each_with_index do |line, index|

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:menuconfig]) || line.starts_with?(ISM::Default::Software::KconfigKeywords[:config]) || line.starts_with?(ISM::Default::Software::KconfigKeywords[:if]) || line.starts_with?(ISM::Default::Software::KconfigKeywords[:endif])

                    if index > 0

                        #IF LAST DEPENDENCY IS A MENUCONFIG
                        if lastIfIndex < lastEndIfIndex || lastIfIndex > lastEndIfIndex && lastMenuConfigIndex > lastIfIndex
                            kernelOption.dependencies = kernelOption.dependencies+[lastMenuConfigContent]
                        end

                        #IF LAST DEPENDENCY IS A IF
                        if lastIfIndex > lastEndIfIndex && lastIfIndex > lastMenuConfigIndex
                            kernelOption.dependencies = kernelOption.dependencies+[lastIfContent]
                        end

                        kernelOptions.push(kernelOption.dup)

                    end

                    kernelOption = ISM::KernelOption.new
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:menuconfig])
                    lastMenuConfigIndex = index
                    lastMenuConfigContent = line.gsub(ISM::Default::Software::KconfigKeywords[:menuconfig],"")
                    kernelOption.name = line.gsub(ISM::Default::Software::KconfigKeywords[:menuconfig],"")
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:config])
                    kernelOption.name = line.gsub(ISM::Default::Software::KconfigKeywords[:config],"")
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:bool])
                    kernelOption.tristate = false
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:tristate])
                    kernelOption.tristate = true
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:dependsOn])

                    newDependencies,newSingleChoiceDependencies,newBlockers = parseKconfigConditions(line.gsub(ISM::Default::Software::KconfigKeywords[:dependsOn],""))

                    kernelOption.dependencies += newDependencies
                    kernelOption.singleChoiceDependencies += newSingleChoiceDependencies
                    kernelOption.blockers += newBlockers
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:select])

                    newDependencies,newSingleChoiceDependencies,newBlockers = parseKconfigConditions(line.gsub(ISM::Default::Software::KconfigKeywords[:select],""))

                    kernelOption.dependencies += newDependencies
                    kernelOption.singleChoiceDependencies += newSingleChoiceDependencies
                    kernelOption.blockers += newBlockers
                end

                if line.starts_with?(ISM::Default::Software::KconfigKeywords[:if])
                    lastIfIndex = index
                    lastIfContent = line.gsub(ISM::Default::Software::KconfigKeywords[:if],"")
                end

            end

            kernelOptions.each do |option|
                if !option.name.empty?
                    option.writeInformationFile(Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+"/"+kernelName+"/"+option.name+".json")
                end
            end
        end

        def updateKernelOptionsDatabase
            Ism.notifyOfUpdateKernelOptionsDatabase(@information)

            if !Dir.exists?(kernelOptionsDatabasePath)
                makeDirectoryNoChroot(kernelOptionsDatabasePath)

                begin
                    generateKernelOptionsFiles(getFullKernelKconfigFile(kernelKconfigFilePath))
                    generateKernelOptionsFiles(getFullKernelKconfigFile(kernelArchitectureKconfigFilePath))
                rescue error
                    deleteDirectoryNoChroot(kernelOptionsDatabasePath)

                    Ism.notifyOfUpdateKernelOptionsDatabaseError(@information, error)
                    Ism.exitProgram
                end
            end
        end

        def recordNeededKernelFeatures
            Ism.notifyOfRecordNeededKernelFeatures(@information)
            Ism.neededKernelFeatures += @information.kernelDependencies
        end
        
        def clean
            Ism.notifyOfClean(@information)
            cleanWorkDirectoryPath
        end

        def cleanWorkDirectoryPath
            if Dir.exists?(workDirectoryPathNoChroot)
                deleteDirectoryNoChroot(workDirectoryPathNoChroot)
            end

            makeDirectoryNoChroot(workDirectoryPathNoChroot)
        end

        def recordUnneededKernelFeatures
            Ism.notifyOfRecordUnneededKernelFeatures(@information)
            Ism.unneededKernelFeatures += @information.kernelDependencies
        end

        def showInformations
            puts
            Ism.printInformationNotificationTitle(@information.name,@information.version)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)
            Ism.removeInstalledSoftware(@information)
        end

        def option(optionName : String) : Bool
            return @information.option(optionName)
        end

        def softwareIsInstalled(softwareName : String) : Bool
            return Ism.softwareAnyVersionInstalled(softwareName)
        end

        def architecture(architecture : String) : Bool
            return Ism.settings.systemArchitecture == architecture
        end

        def showInfo(message : String)
            Ism.printInformationNotification(message)
        end

        def showInfoCode(message : String)
            Ism.printInformationCodeNotification(message)
        end

    end

end
