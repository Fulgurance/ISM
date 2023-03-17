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
            process = Process.run("wget",   args: [link],
                                            output: :inherit,
                                            error: :inherit,
                                            chdir: workDirectoryPath(false))
            if !process.success?
                Ism.notifyOfDownloadError(link)
                Ism.exitProgram
            end
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
                extractSource(source.lchop(source[0..source.rindex("/")]))
            end

            @information.options.each do |option|
                if option.active
                    option.downloadLinks.each do |source|
                        extractSource(source.lchop(source[0..source.rindex("/")]))
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

        def runScript(file : String, arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            scriptCommand = "./#{file}"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootScriptCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{scriptCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootScriptCommand)
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
                Ism.exitProgram
            end
        end

        def runPythonScript(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            pythonCommand = "python"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootPythonScriptCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{pythonCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootPythonScriptCommand)
            else
                process = Process.run(  pythonCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunPythonScriptError(path)
                Ism.exitProgram
            end
        end

        def runCrystalCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            crystalCommand = "crystal"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootCrystalCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{crystalCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootCrystalCommand)
            else
                process = Process.run(  crystalCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunCrystalCommandError(path)
                Ism.exitProgram
            end
        end

        def runCmakeCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            cmakeCommand = "cmake"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootCmakeCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{cmakeCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootCmakeCommand)
            else
                process = Process.run(  cmakeCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunCmakeCommandError(path)
                Ism.exitProgram
            end
        end

        def runMesonCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            mesonCommand = "meson"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootMesonCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{mesonCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootMesonCommand)
            else
                process = Process.run(  mesonCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunMesonCommandError(path)
                Ism.exitProgram
            end
        end

        def runNinjaCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            ninjaCommand = "ninja"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootNinjaCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{ninjaCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootNinjaCommand)
            else
                process = Process.run(  ninjaCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunNinjaCommandError(path)
                Ism.exitProgram
            end
        end

        def runPwconvCommand(arguments = Array(String).new)
            pwconvCommand = "pwconv"

            if Ism.settings.installByChroot
                chrootPwconvScriptCommand = <<-CODE
                #!/bin/bash
                #{pwconvCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootPwconvScriptCommand)
            else
                process = Process.run(  pwconvCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunPwconvCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runGrpconvCommand(arguments = Array(String).new)
            grpconvCommand = "grpconv"

            if Ism.settings.installByChroot
                chrootGrpconvScriptCommand = <<-CODE
                #!/bin/bash
                #{grpconvCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootGrpconvScriptCommand)
            else
                process = Process.run(  grpconvCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunGrpconvCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runUdevadmCommand(arguments : Array(String))
            udevadmCommand = "udevadm"

            if Ism.settings.installByChroot
                chrootUdevadmScriptCommand = <<-CODE
                #!/bin/bash
                #{udevadmCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootUdevadmScriptCommand)
            else
                process = Process.run(  udevadmCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunUdevadmCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runDbusUuidgenCommand(arguments = Array(String).new)
            dbusUuidgenCommand = "dbus-uuidgen"

            if Ism.settings.installByChroot
                chrootDbusUuidgenScriptCommand = <<-CODE
                #!/bin/bash
                #{dbusUuidgenCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootDbusUuidgenScriptCommand)
            else
                process = Process.run(  dbusUuidgenCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunDbusUuidgenCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runMakeinfoCommand(arguments : Array(String), path = String.new)
            process = Process.run("makeinfo",   args: arguments,
                                                chdir: path)

            if !process.success?
                Ism.notifyOfRunMakeinfoCommandError(path)
                Ism.exitProgram
            end
        end

        def runInstallInfoCommand(arguments : Array(String))
            installInfoCommand = "install-info"

            if Ism.settings.installByChroot
                chrootInstallInfoScriptCommand = <<-CODE
                #!/bin/bash
                #{installInfoCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootInstallInfoScriptCommand)
            else
                process = Process.run(  installInfoCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunInstallInfoCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runAutoreconfCommand(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            autoreconfCommand = "autoreconf"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootAutoreconfCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{autoreconfCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootAutoreconfCommand)
            else
                process = Process.run(  autoreconfCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfRunAutoreconfCommandError(path)
                Ism.exitProgram
            end
        end

        def runLocaledefCommand(arguments : Array(String))
            localedefCommand = "localedef"

            if Ism.settings.installByChroot
                chrootLocaledefScriptCommand = <<-CODE
                #!/bin/bash
                #{localedefCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootLocaledefScriptCommand)
            else
                process = Process.run(  localedefCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunLocaledefCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runGunzipCommand(arguments : Array(String), path = String.new)
            gunzipCommand = "gunzip"

            if Ism.settings.installByChroot
                chrootGunzipCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{gunzipCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootGunzipCommand)
            else
                process = Process.run(  gunzipCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path)
            end

            if !process.success?
                Ism.notifyOfRunGunzipCommandError(path)
                Ism.exitProgram
            end
        end

        def runMakeCaCommand(arguments : Array(String))
            makeCaCommand = "make-ca"

            if Ism.settings.installByChroot
                chrootMakeCaScriptCommand = <<-CODE
                #!/bin/bash
                #{makeCaCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootMakeCaScriptCommand)
            else
                process = Process.run(  makeCaCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunMakeCaCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runInstallCatalogCommand(arguments : Array(String))
            installCatalogCommand = "install-catalog"

            if Ism.settings.installByChroot
                chrootInstallCatalogScriptCommand = <<-CODE
                #!/bin/bash
                #{installCatalogCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootInstallCatalogScriptCommand)
            else
                process = Process.run(  installCatalogCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunInstallCatalogCommandError(arguments)
                Ism.exitProgram
            end
        end

        def runXmlCatalogCommand(arguments : Array(String))
            xmlCatalogCommand = "xmlcatalog"

            if Ism.settings.installByChroot
                chrootXmlCatalogScriptCommand = <<-CODE
                #!/bin/bash
                #{xmlCatalogCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootXmlCatalogScriptCommand)
            else
                process = Process.run(  xmlCatalogCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true)
            end
            if !process.success?
                Ism.notifyOfRunXmlCatalogCommandError(arguments)
                Ism.exitProgram
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
                Ism.exitProgram
            end
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makePerlSource(path = String.new)
            if Ism.settings.installByChroot
                chrootPerlCommand = <<-CODE
                #!/bin/bash
                cd #{path} && perl Makefile.PL
                CODE

                process = runChrootTasks(chrootPerlCommand)
            else
                process = Process.run("perl",   args: ["Makefile.PL"],
                                                output: :inherit,
                                                error: :inherit,
                                                chdir: path)
            end
            if !process.success?
                Ism.notifyOfMakePerlSourceError(path)
                Ism.exitProgram
            end
        end

        def makeSource(arguments = Array(String).new, path = String.new, environment = Hash(String, String).new)
            makeSourceCommand = "make"
            environmentCommand = (environment.map { |key| key.join("=") }).join(" ")

            if Ism.settings.installByChroot
                chrootMakeSourceCommand = <<-CODE
                #!/bin/bash
                cd #{path} && #{environmentCommand} #{makeSourceCommand} #{arguments.join(" ")}
                CODE

                process = runChrootTasks(chrootMakeSourceCommand)
            else
                process = Process.run(  makeSourceCommand,
                                        args: arguments,
                                        output: :inherit,
                                        error: :inherit,
                                        shell: true,
                                        chdir: path,
                                        env: environment)
            end
            if !process.success?
                Ism.notifyOfMakeSourceError(path)
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
