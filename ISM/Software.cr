module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String
        property buildDirectory : Bool
        property buildDirectoryNames : Hash(String,String)

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.loadConfiguration(informationPath)
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
        def mainWorkDirectoryPathNoChroot : String
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

        def recordSelectedKernel
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            settingInformation = ISM::SoftwareInformation.loadConfiguration(@information.settingsFilePath)

            settingInformation.uniqueDependencies.each do |uniqueDependency|
                uniqueDependency.each do |entry|

                    if settingInformation.uniqueDependencyIsEnabled(entry)

                        settingInformation.dependencies(allowDeepSearch: true).each do |dependency|
                            if dependency.fullName.downcase == entry.downcase
                                dependency.information.writeConfiguration("#{Ism.settings.rootPath}#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::SelectedKernel}")
                            end
                        end
                    end
                end
            end

            #Raise an error if nothing found
        end

        def mainKernelName : String
            return Ism.selectedKernel.versionName.downcase
        end

        def mainKernelVersion : String
            return Ism.selectedKernel.version
        end

        def prepareKernelSourcesInstallation
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            makeDirectoryNoChroot("#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}usr/src/")
            moveFileNoChroot("#{workDirectoryPathNoChroot}/Sources","#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}usr/src/#{@information.versionName.downcase}")
        end

        def download
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

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
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            downloadFile(   @information.sourcesLink,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveExtensionName)
        end

        def downloadSourcesMd5sum
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            downloadFile(   @information.sourcesMd5sumLink,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveMd5sumExtensionName)
        end

        def remoteFileIsAvailable(fileUrl : String) : Bool
            response = HTTP::Client.get(fileUrl)

            return response.status == HTTP::Status::OK
        end

        def downloadPatches
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            downloadFile(   @information.patchesLink,
                                ISM::Default::Software::PatchesArchiveBaseName,
                                ISM::Default::Software::ArchiveExtensionName)
        end

        def downloadPatchesMd5sum
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            downloadFile(   @information.patchesMd5sumLink,
                            ISM::Default::Software::PatchesArchiveBaseName,
                            ISM::Default::Software::ArchiveMd5sumExtensionName)
        end

        def downloadFile(link : String, filename : String, fileExtensionName : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            originalLink = link
            downloaded = false
            error = String.new
            startingTime = Time.monotonic

            until downloaded
                HTTP::Client.get(link) do |response|
                    #Program exit if the first download take over 1500 ms (EXPERIMENTAL)
                    #if (Time.monotonic - startingTime).milliseconds > 1500
                        #Ism.notifyOfConnexionError(link)
                        #Ism.exitProgram
                    #end

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

                    filePath = "#{workDirectoryPathNoChroot}/#{filename+fileExtensionName}"
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
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath, error)
                Ism.exitProgram
            end
            return content
        end

        def check
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            Ism.notifyOfCheck(@information)

            checkSourcesMd5sum
            if File.exists?(workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesMd5sumArchiveName)
                checkPatchesMd5sum
            end
        end

        def checkSourcesMd5sum
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            checkFile(  workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesArchiveName,
                        getFileContent(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesMd5sumArchiveName).strip)
        end

        def checkPatchesMd5sum
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            checkFile(  workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesArchiveName,
                        getFileContent(workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesMd5sumArchiveName).strip)
        end

        def checkFile(archive : String, md5sum : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            digest = Digest::MD5.new
            digest.file(archive)
            archiveMd5sum = digest.hexfinal

            if archiveMd5sum != md5sum
                Ism.notifyOfCheckError(archive, md5sum)
                Ism.exitProgram
            end
        end

        def extract
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            Ism.notifyOfExtract(@information)

            extractSources
            if File.exists?(workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesMd5sumArchiveName)
                extractPatches
            end
        end

        def extractSources
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            extractArchive(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesArchiveName, workDirectoryPathNoChroot)
            moveFileNoChroot(workDirectoryPathNoChroot+"/"+@information.versionName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesDirectoryName)
        end

        def extractPatches
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            extractArchive(workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesArchiveName, workDirectoryPathNoChroot)
            moveFileNoChroot(workDirectoryPathNoChroot+"/"+@information.versionName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName)
        end

        def extractArchive(archivePath : String, destinationPath = workDirectoryPathNoChroot)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            process = Process.run(  "tar -xf #{archivePath}",
                                    shell: true,
                                    chdir: destinationPath)
            if !process.success?
                Ism.notifyOfExtractError(archivePath, destinationPath)
                Ism.exitProgram
            end
        end
        
        def patch
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            Ism.notifyOfPatch(@information)

            if Dir.exists?("#{workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName}")
                Dir["#{workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName}/*"].each do |patch|
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
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            process = Process.run(  "patch -Np1 -i #{patch}",
                                    error: :inherit,
                                    shell: true,
                                    chdir: mainWorkDirectoryPathNoChroot)
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                Ism.exitProgram
            end
        end

        def prepare
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            Ism.notifyOfPrepare(@information)

            #Generate all build directories
            @buildDirectoryNames.keys.each do |key|
                if !Dir.exists?(buildDirectoryPathNoChroot(key))
                    makeDirectoryNoChroot(buildDirectoryPathNoChroot(key))
                end
            end
        end

        #Special function to improve performance (Internal use only)
        def copyFileNoChroot(path : String, targetPath : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                FileUtils.cp(path, targetPath)
            rescue error
                Ism.notifyOfCopyFileError(path, targetPath, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def copyDirectoryNoChroot(path : String, targetPath : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                FileUtils.cp_r(path, targetPath)
            rescue error
                Ism.notifyOfCopyDirectoryError(path, targetPath, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def deleteFileNoChroot(path : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                FileUtils.rm(path)
            rescue error
                Ism.notifyOfDeleteFileError(path, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def moveFileNoChroot(path : String, newPath : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                FileUtils.mv(path, newPath)
            rescue error
                Ism.notifyOfMoveFileError(path, newPath, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def makeDirectoryNoChroot(directory : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                FileUtils.mkdir_p(directory)
            rescue error
                Ism.notifyOfMakeDirectoryError(directory, error)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def deleteDirectoryNoChroot(directory : String)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            begin
                FileUtils.rm_r(directory)
            rescue error
                Ism.notifyOfDeleteDirectoryError(directory, error)
                Ism.exitProgram
            end
        end

        def runChrootTasks(chrootTasks) : Process::Status
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

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

        def runSystemCommand(command : String, path = Ism.settings.installByChroot ? "/" : Ism.settings.rootPath, environment = Hash(String, String).new, environmentFilePath = String.new) : Process::Status
            environmentCommand = String.new

            if environmentFilePath != ""
                environmentCommand = "source \"#{environmentFilePath}\" && "
            end

            environment.keys.each do |key|
                environmentCommand += " #{key}=\"#{environment[key]}\""
            end

            Ism.recordSystemCall(command, path, environment)

            if Ism.settings.installByChroot
                chrootCommand = <<-CODE
                #!/bin/bash

                if \[ -f "/etc/profile"\]; then
                    source /etc/profile
                fi

                cd #{path} && #{environmentCommand} #{command}
                CODE

                process = runChrootTasks(chrootCommand)
            else
                environmentHash = Hash(String, String).new

                #Substitute all environment variables by the real value
                environment.keys.each do |key|
                    environmentHash[key] = environment[key].gsub(/\$([A-Z0-9]+)/) do |_, match|
                        begin
                            ENV[match[1]]
                        rescue
                            #Return empty string if the var don't exist
                            String.new
                        end
                    end
                end

                process = Process.run(  command,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: (path == "" ? nil : path),
                                        env: environmentHash)
            end

            return process
        end

        def fileUpdateContent(path : String, data : String)
            requestedCommands = <<-CMD
                                grep -q '#{data}' '#{path}' || echo "#{data}" >> '#{path}'
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceText(path : String, text : String, newText : String)
            requestedCommands = <<-CMD
                                sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/g' #{path}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceLineContaining(path : String, text : String, newLine : String)
            requestedCommands = <<-CMD
                                sed -i '/#{text.gsub(/([\.\/])/, %q(\\\1))}/c\#{newText.gsub(/([\.\/])/, %q(\\\1))}' #{path}
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceTextAtLineNumber(path : String, text : String, newText : String,lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}s/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' #{path}
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
                                cat > #{path} <<"EOF"
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
                                echo "#{data}" > "#{path}"
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileAppendDataFromFile(path : String, fromPath : String)
            requestedCommands = <<-CMD
                                cat "#{fromPath}" >> "#{path}"
                                CMD

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            requestedCommands = <<-CMD
                                find -name #{filename} -exec sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' {} \\;
                                CMD

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def deleteAllFilesRecursivelyFinishing(path : String, extensions = Array(String).new)
            extensionCommands = String.new

            extensions.each do |extension|
                extensionCommands += ("-name")
                extensionCommands += ("\\*.#{extension} ")
            end

            requestedCommands = <<-CMD
                                find #{path} -name \*.la -delete
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

            requestedCommands = "#{command} '#{target}' #{path}"

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

        def runFile(file : String, arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "./#{file} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runTarCommand(arguments = String.new, path = String.new)
            requestedCommands = "tar #{arguments}"

            process = runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runPythonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "python #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runPipCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "pip #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runCrystalCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "crystal #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runCmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                #prefix =    "--parallel #{makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions}"

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end
            else
                #prefix =    "--parallel #{makeOptions == "" ? Ism.settings.systemMakeOptions : makeOptions} "

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end
            end

            #requestedCommands = "cmake #{prefix} #{arguments}"
            requestedCommands = "cmake #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runMesonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "meson #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runNinjaCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                prefix =    "#{makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions}"

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end
            else
                prefix =    "#{makeOptions == "" ? Ism.settings.systemMakeOptions : makeOptions} "

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end
            end

            requestedCommands = "ninja #{prefix} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
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

        def runAutoconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoconf #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runAutoreconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoreconf #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
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

        def runXargoCommand(arguments : String, path = String.new)
            requestedCommands = "xargo #{arguments}"

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
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            servicesPath = "/etc/init.d/"

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")
            moveFile(path,"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}#{name}")
            runChmodCommand("+x #{name}","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments = String.new, path = String.new, configureDirectory = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, relatedToMainBuild = true)
            configureCommand = "#{@buildDirectory && relatedToMainBuild ? ".." : "."}/#{configureDirectory}/configure"

            requestedCommands = "#{configureCommand} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
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

        def runDircolorsCommand(arguments = String.new)
            requestedCommands = "dircolors #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runDepmodCommand(arguments = String.new)
            requestedCommands = "depmod #{arguments}"

            process = runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(arguments)
                Ism.exitProgram
            end
        end

        def makeSource(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot
                prefix = "#{makeOptions == "" ? Ism.settings.chrootMakeOptions : makeOptions}"

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end
            else
                prefix =    "#{makeOptions == "" ? Ism.settings.systemMakeOptions : makeOptions} "

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end
            end

            requestedCommands = "make #{prefix} #{arguments}"

            process = runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def recordInstallationInformation : Tuple(UInt128, UInt128, UInt128, UInt128)
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            directoryNumber = UInt128.new(0)
            symlinkNumber = UInt128.new(0)
            fileNumber = UInt128.new(0)
            totalSize = UInt128.new(0)

            filesList = Dir.glob(["#{builtSoftwareDirectoryPathNoChroot}/**/*"], match: :dot_files)

            directoryNumber = UInt128.new(0)
            symlinkNumber = UInt128.new(0)
            fileNumber = UInt128.new(0)
            totalSize = UInt128.new(0)

            filesList.each do |entry|

                finalDestination = "/#{entry.sub(builtSoftwareDirectoryPathNoChroot,"")}"

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
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            Ism.notifyOfInstall(@information)

            filesList = Dir.glob(["#{builtSoftwareDirectoryPathNoChroot}/**/*"], match: :dot_files)
            installedFiles = Array(String).new

            filesList.each do |entry|

                finalDestination = "/#{entry.sub(builtSoftwareDirectoryPathNoChroot,"")}"
                recordedFilePath = "/#{finalDestination.sub(Ism.settings.rootPath,"")}".squeeze("/")

                if !File.exists?(finalDestination) || Ism.softwareIsInstalled(@information) && ISM::SoftwareInformation.loadConfiguration(@information.installedFilePath).installedFiles.includes?(recordedFilePath)
                    installedFiles << recordedFilePath
                end

                if File.directory?(entry) && !File.symlink?(entry)
                    if !Dir.exists?(finalDestination)
                        makeDirectoryNoChroot(finalDestination)
                    end
                else
                    moveFileNoChroot(entry,finalDestination)
                end
            end

            Ism.addInstalledSoftware(@information, installedFiles)
        end

        def kernelSourcesPath : String
            return "#{Ism.settings.rootPath}usr/src/#{mainKernelName}/"
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
            return Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+mainKernelName
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

                if !result.any? {|line| line.lstrip.starts_with?(ISM::Default::Software::KconfigKeywords[:source])}
                    break
                end

                nextResult.clear

                result.each do |line|
                    text = line.lstrip

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:source]) && !text.includes?("Kconfig.include")

                        mainArchitecture = (Ism.settings.installByChroot ? Ism.settings.chrootArchitecture : Ism.settings.systemArchitecture).gsub(/_.*/,"")

                        path = kernelSourcesPath+text.sub(ISM::Default::Software::KconfigKeywords[:source],"").strip
                        path = path.gsub("\"","")
                        path = path.gsub("$(SRCARCH)","#{mainArchitecture}")
                        path = path.gsub("$(HEADER_ARCH)","#{mainArchitecture}")

                        begin
                            temp = File.read_lines(path)
                            nextResult += temp
                        rescue
                            nextResult += Array(String).new
                        end

                    elsif text.starts_with?(ISM::Default::Software::KconfigKeywords[:source]) && text.includes?("Kconfig.include")
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
            underHelpSection = false
            lastHelpAlignmentSize = 0
            currentLignAligmentSize = 0

            kconfigContent.each_with_index do |line, index|
                text = line.lstrip
                currentLignAligmentSize = (line.size - text.size)

                if !underHelpSection && text.starts_with?(ISM::Default::Software::KconfigKeywords[:help])

                    underHelpSection = true
                    lastHelpAlignmentSize = (line.size - text.size)

                elsif !underHelpSection

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:menuconfig])
                        lastMenuConfigIndex = index
                        lastMenuConfigContent = text.sub(ISM::Default::Software::KconfigKeywords[:menuconfig],"").lstrip

                        kernelOption = ISM::KernelOption.new
                        kernelOption.name = text.sub(ISM::Default::Software::KconfigKeywords[:menuconfig],"").lstrip
                    end

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:config])
                        kernelOption = ISM::KernelOption.new
                        kernelOption.name = text.sub(ISM::Default::Software::KconfigKeywords[:config],"").lstrip
                    end

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:bool])
                        kernelOption.tristate = false
                    end

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:tristate])
                        kernelOption.tristate = true
                    end

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:dependsOn])

                        newDependencies,newSingleChoiceDependencies,newBlockers = parseKconfigConditions(text.sub(ISM::Default::Software::KconfigKeywords[:dependsOn],"").lstrip)

                        kernelOption.dependencies += newDependencies
                        kernelOption.singleChoiceDependencies += newSingleChoiceDependencies
                        kernelOption.blockers += newBlockers
                    end

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:select])

                        newDependencies,newSingleChoiceDependencies,newBlockers = parseKconfigConditions(text.sub(ISM::Default::Software::KconfigKeywords[:select],"").lstrip)

                        kernelOption.dependencies += newDependencies
                        kernelOption.singleChoiceDependencies += newSingleChoiceDependencies
                        kernelOption.blockers += newBlockers
                    end

                    if text.starts_with?(ISM::Default::Software::KconfigKeywords[:if])
                        lastIfIndex = index
                        lastIfContent = text.sub(ISM::Default::Software::KconfigKeywords[:if],"").lstrip
                    end
                else
                    if currentLignAligmentSize <= lastHelpAlignmentSize
                        underHelpSection = false

                        #IF LAST DEPENDENCY IS A MENUCONFIG
                        if lastIfIndex < lastEndIfIndex || lastIfIndex > lastEndIfIndex && lastMenuConfigIndex > lastIfIndex
                            kernelOption.dependencies = kernelOption.dependencies+[lastMenuConfigContent]
                        end

                        #IF LAST DEPENDENCY IS A IF
                        if lastIfIndex > lastEndIfIndex && lastIfIndex > lastMenuConfigIndex
                            kernelOption.dependencies = kernelOption.dependencies+[lastIfContent]
                        end

                        kernelOptions.push(kernelOption.dup)

                    else

                        kernelOption.description += text

                    end
                end

            end

            kernelOptions.each do |option|
                if !option.name.empty?
                    option.writeConfiguration(Ism.settings.rootPath+ISM::Default::Path::KernelOptionsDirectory+"/"+mainKernelName+"/"+option.name+".json")
                end
            end
        end

        def updateKernelOptionsDatabase
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            Ism.notifyOfUpdateKernelOptionsDatabase(Ism.selectedKernel)

            makeDirectoryNoChroot(kernelOptionsDatabasePath)

            begin
                generateKernelOptionsFiles(getFullKernelKconfigFile(kernelKconfigFilePath))
                generateKernelOptionsFiles(getFullKernelKconfigFile(kernelArchitectureKconfigFilePath))
            rescue error
                deleteDirectoryNoChroot(kernelOptionsDatabasePath)

                Ism.notifyOfUpdateKernelOptionsDatabaseError(Ism.selectedKernel, error)
                Ism.exitProgram
            end
        end

        def recordNeededKernelFeatures
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            #Ism.notifyOfRecordNeededKernelFeatures(Ism.selectedKernel)

            #Ism.neededKernelFeatures += Ism.selectedKernel.kernelDependencies
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
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            #Ism.notifyOfRecordUnneededKernelFeatures(Ism.selectedKernel)

            #Ism.unneededKernelFeatures += Ism.selectedKernel.kernelDependencies
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

        def dependency(fullName : String) : ISM::SoftwareInformation
            @information.dependencies(unsorted: true).each do |entry|
                if entry.fullName == fullName
                    return entry.information
                end
            end

            return ISM::SoftwareInformation.new
        end

        def isGreatestVersion : Bool
            return Ism.getSoftwareInformation(@information.fullName).version <= @information.version
        end

        def majorVersion : Int32
            return SemanticVersion.parse(@information.version).major
        end

        #Internal use, or can bring internal error when called in installation script. Use softwareMajorVersion instead
        def dependencyMajorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).major
        end

        def softwareMajorVersion(fullName : String) : Int32
            Ism.recordSystemCall(command: "#{{% @def.receiver %}}.#{{% @def.name %}}")

            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyMajorVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).major
            end
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
