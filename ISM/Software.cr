module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String
        property buildDirectory : Bool
        property buildDirectoryNames : Hash(String,String)
        property additions : Array(String)

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.loadConfiguration(informationPath)
            @mainSourceDirectoryName = ISM::Default::Software::SourcesDirectoryName
            @buildDirectory = false
            @buildDirectoryNames = { ISM::Default::Software::MainBuildDirectoryEntry => "mainBuild" }
            @additions = Array(String).new
        end

        def autoDeployServices
            return Ism.settings.autoDeployServices
        end

        def systemId : String
            return ISM::Default::CommandLine::Id.to_s
        end

        def recordCrossToolchainAsFullyBuilt
            Ism.systemInformation.setCrossToolchainFullyBuilt(true)
        end

        def recordHandleChroot
            Ism.systemInformation.setHandleChroot(true)
        end

        def version : String
            return @information.version
        end

        def name : String
            return @information.name
        end

        def versionName : String
            return @information.versionName
        end

        def passEnabled : Bool
            return @information.passEnabled
        end

        #Special function to improve performance (Internal use only)
        def workDirectoryPathNoChroot : String
            return Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version
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
            return Ism.targetSystemInformation.handleChroot ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.port+"/"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version
        end

        def mainWorkDirectoryPath : String
            return workDirectoryPath+"/"+@mainSourceDirectoryName
        end

        def buildDirectoryPath(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPath+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"
        end

        def builtSoftwareDirectoryPath : String
            return Ism.targetSystemInformation.handleChroot ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"
        end

        def directoryContent(path : String, matchHidden = false) : Array(String)
            path = "#{path}/*"

            fileList = Dir.glob((Ism.targetSystemInformation.handleChroot ? Ism.settings.rootPath+path : path), match: (matchHidden ? File::MatchOptions.glob_default : File::MatchOptions::None))

            return fileList.map { |file| (Ism.targetSystemInformation.handleChroot ? file[(Ism.settings.rootPath.size-1)..-1] : file)}

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "directoryContent",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def recordSelectedKernel
            settingInformation = ISM::SoftwareInformation.loadConfiguration(@information.settingsFilePath)

            settingInformation.uniqueDependencies.each do |uniqueDependency|
                uniqueDependency.each do |entry|

                    if settingInformation.uniqueDependencyIsEnabled(entry)

                        settingInformation.dependencies(allowDeepSearch: true).each do |dependency|
                            if dependency.fullName.downcase == entry.downcase

                                needUpdateKernelFile = false

                                if selectedKernel.isValid
                                    installedVersion = SemanticVersion.parse(Ism.mainKernelVersion)
                                    availableVersion = SemanticVersion.parse(Ism.getSoftwareInformation(entry).version)

                                    if selectedKernel.fullName.downcase == entry.downcase && availableVersion > installedVersion
                                        needUpdateKernelFile = true
                                    end
                                else
                                    needUpdateKernelFile = true
                                end

                                #Record kernel as default if it's a newer version of the selected one OR if none are selected
                                if needUpdateKernelFile
                                    dependency.information.writeConfiguration("#{Ism.settings.rootPath}#{ISM::Default::Path::SettingsDirectory}#{ISM::Default::Filename::SelectedKernel}")
                                end

                            end
                        end

                    end
                end
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "recordSelectedKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def mainKernelHeadersName : String
            return Ism.mainKernelHeadersName
        end

        def mainKernelName : String
            return Ism.mainKernelName
        end

        def mainKernelVersion : String
            return Ism.mainKernelVersion
        end

        def updateKernelSymlinks

            #Create/Update symlinks if needed
            if !kernelIsSelected || isCurrentKernel
                #Make link for the current running kernel sources
                makeLink(   target: "#{@information.versionName.downcase}",
                            path:   "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/main-kernel-sources",
                            type:   :symbolicLinkByOverwrite)

                #Make link for the current running kernel source headers
                makeLink(   target: "#{@information.name.downcase}-headers-#{@information.version.downcase}",
                            path:   "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/main-kernel-sources-headers",
                            type:   :symbolicLinkByOverwrite)

                #Make link for the current kernel documentation
                makeLink(   target: "../../src/main-kernel-sources/Documentation",
                            path:   "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/share/doc/main-kernel-sources-documentation",
                            type:   :symbolicLinkByOverwrite)

                #Generate symlinks of the current kernel headers to /usr/include
                headerPath = "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/main-kernel-sources-headers/"
                headerDirectories = Dir.children(headerPath)#.select { |entry| File.directory?("#{headerPath}/#{entry}") } >>> NEED PATCH

                headerDirectories.each do |headerDirectory|
                    makeLink(   target: "../src/main-kernel-sources-headers/#{headerDirectory}",
                                path:   "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/include/#{headerDirectory}",
                                type:   :symbolicLinkByOverwrite)
                end
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "updateKernelSymlinks",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def prepareKernelSourcesInstallation
            makeDirectoryNoChroot("#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/")
            makeDirectoryNoChroot("#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/share/doc/")
            makeDirectoryNoChroot("#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/include")

            #Install the kernel sources
            moveFileNoChroot(   path:       "#{workDirectoryPathNoChroot}/Sources",
                                newPath:    "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/#{@information.versionName.downcase}")

            #Generate headers
            makeSource( arguments:   "clean",
                        path: "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/src/#{@information.versionName.downcase}")

            makeSource( arguments:  "headers",
                        path: "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/src/#{@information.versionName.downcase}")

            #Make a copy of the headers for the system
            copyDirectoryNoChroot(  path:       "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/#{@information.versionName.downcase}/usr/include",
                                    targetPath: "#{builtSoftwareDirectoryPathNoChroot}#{Ism.settings.rootPath}/usr/src/#{@information.name.downcase}-headers-#{@information.version.downcase}")

            updateKernelSymlinks

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "prepareKernelSourcesInstallation",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def selectedKernel
            return Ism.selectedKernel
        end

        def kernelIsSelected
            return Ism.kernelIsSelected
        end

        def cleanKernelSources
            return Ism.cleanKernelSources
        end

        def generateKernelConfiguration
            return Ism.generateKernelConfiguration
        end

        def buildKernel
            return Ism.buildKernel
        end

        def installKernel
            return Ism.installKernel
        end

        def setupChrootPermissions
            Ism.notifyOfSetupChrootPermissions

            commandList = Array(String).new

            setUpRoot = <<-COMMAND
            find #{Ism.settings.rootPath} \
            -path #{Ism.settings.sourcesPath[0..-2]} -prune \
            -o -path #{Ism.settings.toolsPath[0..-2]} -prune \
            -o -path #{Ism.settings.rootPath}#{ISM::Default::Path::RuntimeDataDirectory[0..-2]} -prune \
            -o -path #{Ism.settings.rootPath}#{ISM::Default::Path::TemporaryDirectory[0..-2]} -prune \
            -o -path #{Ism.settings.rootPath}#{ISM::Default::Path::SettingsDirectory[0..-2]} -prune \
            -o -path #{Ism.settings.rootPath}#{ISM::Default::Path::LogsDirectory[0..-2]} -prune \
            -o -exec chown --no-dereference root:root {} +
            COMMAND

            commandList.push(setUpRoot)
            commandList.push("/usr/bin/chmod 0750 #{Ism.settings.rootPath}/root")
            commandList.push("/usr/bin/chmod 1777 #{Ism.settings.rootPath}/tmp")
            commandList.push("/usr/bin/chmod 1777 #{Ism.settings.rootPath}/var/tmp")

            process = Ism.runSystemCommand( command: commandList,
                                            viaChroot: false,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootPermissions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootProc
            Ism.notifyOfPrepareChrootProc

            requestedCommands = "/usr/bin/mount --types proc /proc #{Ism.settings.rootPath}/proc"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            viaChroot: false,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootProc",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootSys
            Ism.notifyOfPrepareChrootSys

            requestedCommands = "/usr/bin/mount --rbind /sys #{Ism.settings.rootPath}/sys"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            viaChroot: false,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootSys",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootDev
            Ism.notifyOfPrepareChrootDev

            requestedCommands = "/usr/bin/mount --rbind /dev #{Ism.settings.rootPath}/dev"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            viaChroot: false,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootDev",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootRun
            Ism.notifyOfPrepareChrootRun

            requestedCommands = "/usr/bin/mount --bind /run #{Ism.settings.rootPath}/run"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            viaChroot: false,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootRun",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootNetwork
            Ism.notifyOfPrepareChrootNetwork

            requestedCommands = "/usr/bin/cp --dereference /etc/resolv.conf #{Ism.settings.rootPath}/etc/resolv.conf"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            viaChroot: false,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootRun",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def prepareChrootFileSystem
            Ism.unlockSystemAccess

            setupChrootPermissions
            prepareChrootProc
            prepareChrootSys
            prepareChrootDev
            prepareChrootRun
            prepareChrootNetwork

            Ism.lockSystemAccess

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "prepareChrootFileSystem",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setup
        end

        def download
            Ism.notifyOfDownload(@information)

            cleanWorkDirectoryPath

            downloadSources
            downloadSourcesSha512

            if !@additions.empty?
                downloadAdditions
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "download",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def downloadAdditions
            Ism.notifyOfDownloadAdditions

            downloadAdditionalSources
            downloadAdditionalSourcesSha512

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "downloadAdditions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def downloadAdditionalSources
            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")]).gsub(ISM::Default::Software::ArchiveExtensionName,"")

                downloadFile(   link,
                                archiveName,
                                ISM::Default::Software::ArchiveExtensionName)
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "downloadAdditionalSources",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def downloadAdditionalSourcesSha512
            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")]).gsub(ISM::Default::Software::ArchiveExtensionName,"")
                sha512Link = "#{link.gsub(ISM::Default::Software::ArchiveExtensionName,"")}#{ISM::Default::Software::ArchiveSha512ExtensionName}"

                downloadFile(   sha512Link,
                                archiveName,
                                ISM::Default::Software::ArchiveSha512ExtensionName)
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "downloadAdditionalSourcesSha512",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def downloadSources
            downloadFile(   @information.sourcesLink,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveExtensionName)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "downloadSources",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def downloadSourcesSha512
            downloadFile(   @information.sourcesSha512Link,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveSha512ExtensionName)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "downloadSourcesSha512",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def downloadFile(link : String, filename : String, fileExtensionName : String)
            originalLink = link
            downloaded = false
            error = String.new
            startingTime = Time.monotonic

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

                    filePath = "#{workDirectoryPathNoChroot}/#{filename+fileExtensionName}"
                    colorizedFileFullName = "#{filename}#{fileExtensionName.colorize(Colorize::ColorRGB.new(255,100,100))}"
                    colorizedLink = "#{link.colorize(:magenta)}"

                    lastSpeedUpdate = Time.monotonic
                    average = 0
                    bytesLastPeriod = 0

                    if response.status_code == 200
                        buffer = Bytes.new(65536)
                        totalRead = Int64.new(0)
                        lenght = response.headers["Content-Length"]? ? response.headers["Content-Length"].to_i64 : Int64.new(0)

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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "downloadFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end
        
        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath, error)
                Ism.exitProgram
            end
            return content

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "getFileContent",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def check
            Ism.notifyOfCheck(@information)

            checkSourcesSha512

            if !@additions.empty?
                checkAdditionsSha512
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "check",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def checkSourcesSha512
            checkFile(  archive:    "#{workDirectoryPathNoChroot}/#{ISM::Default::Software::SourcesArchiveName}",
                        sha512:     getFileContent(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesSha512ArchiveName).strip)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "checkSourcesSha512",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def checkAdditionsSha512
            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")]).gsub(ISM::Default::Software::ArchiveExtensionName,"")

                checkFile(  archive:    "#{workDirectoryPathNoChroot}/#{archiveName}#{ISM::Default::Software::ArchiveExtensionName}",
                            sha512:     getFileContent("#{workDirectoryPathNoChroot}/#{archiveName}#{ISM::Default::Software::ArchiveSha512ExtensionName}").strip)
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "checkAdditionsSha512",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def checkFile(archive : String, sha512 : String)
            digest = Digest::SHA512.new
            digest.file(archive)
            archiveSha512 = digest.hexfinal

            if archiveSha512 != sha512
                Ism.notifyOfCheckError(archive, sha512)
                Ism.exitProgram
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "checkFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def extract
            Ism.notifyOfExtract(@information)

            extractSources

            if !@additions.empty?
                extractAdditions
            end

            #Copy of the current available patches from the port
            if Dir.exists?(@information.mainDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName)
                copyDirectoryNoChroot(@information.mainDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName)
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "extract",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def extractSources
            extractArchive(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesArchiveName, workDirectoryPathNoChroot)
            moveFileNoChroot(workDirectoryPathNoChroot+"/"+@information.versionName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesDirectoryName)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "extractSources",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def extractAdditions
            Ism.notifyOfExtractAdditions

            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")])

                extractArchive("#{workDirectoryPathNoChroot}/#{archiveName}", workDirectoryPathNoChroot)
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "extractAdditions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def extractArchive(archivePath : String, destinationPath = workDirectoryPathNoChroot)
            process = Process.run(  "tar -xf #{archivePath}",
                                    shell: true,
                                    chdir: destinationPath)
            if !process.success?
                Ism.notifyOfExtractError(archivePath, destinationPath)
                Ism.exitProgram
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "extractArchive",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end
        
        def patch
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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "patch",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end
        
        def applyPatch(patch : String)
            process = Process.run(  "patch -Np1 -i #{patch}",
                                    error: :inherit,
                                    shell: true,
                                    chdir: mainWorkDirectoryPathNoChroot)
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                Ism.exitProgram
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "applyPatch",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def prepare
            Ism.notifyOfPrepare(@information)

            #Generate all build directories
            @buildDirectoryNames.keys.each do |key|
                if !Dir.exists?(buildDirectoryPathNoChroot(key))
                    makeDirectoryNoChroot(buildDirectoryPathNoChroot(key))
                end
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "prepare",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def copyFileNoChroot(path : String, targetPath : String)
            FileUtils.cp(path, targetPath)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "copyFileNoChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def copyDirectoryNoChroot(path : String, targetPath : String)
            FileUtils.cp_r(path, targetPath)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "copyDirectoryNoChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def deleteFileNoChroot(path : String)
            FileUtils.rm(path)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "deleteFileNoChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def moveFileNoChroot(path : String, newPath : String)
            FileUtils.mv(path, newPath)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "moveFileNoChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def makeDirectoryNoChroot(path : String)
            FileUtils.mkdir_p(directory)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "makeDirectoryNoChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def deleteDirectoryNoChroot(path : String)
            FileUtils.rm_r(directory)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "deleteDirectoryNoChroot",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileUpdateContent(path : String, data : String)
            requestedCommands = <<-CMD
            grep -q '#{data}' '#{path}' || echo "#{data}" >> '#{path}'
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileUpdateContent",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileReplaceText(path : String, text : String, newText : String)
            requestedCommands = <<-CMD
            sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/g' #{path}
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileReplaceText",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileReplaceLineContaining(path : String, text : String, newLine : String)
            requestedCommands = <<-CMD
            sed -i '/#{text.gsub(/([\.\/])/, %q(\\\1))}/c\#{newText.gsub(/([\.\/])/, %q(\\\1))}' #{path}
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileReplaceLineContaining",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileReplaceTextAtLineNumber(path : String, text : String, newText : String,lineNumber : UInt64)
            requestedCommands = <<-CMD
            sed -i '#{lineNumber.to_s}s/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' #{path}
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileReplaceTextAtLineNumber",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileDeleteLine(path : String, lineNumber : UInt64)
            requestedCommands = <<-CMD
            sed -i '#{lineNumber.to_s}d' #{path}
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileDeleteLine",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileWriteData(path : String, data : String)
            requestedCommands = <<-CMD
            cat > #{path} <<"EOF"
            #{data}
            EOF
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileWriteData",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileAppendData(path : String, data : String)
            requestedCommands = <<-CMD
            echo "#{data}" > "#{path}"
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileAppendData",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def fileAppendDataFromFile(path : String, fromPath : String)
            requestedCommands = <<-CMD
            cat "#{fromPath}" >> "#{path}"
            CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "fileAppendDataFromFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            requestedCommands = <<-CMD
            find -name #{filename} -exec sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' {} \\;
            CMD

            process = Ism.runSystemCommand(requestedCommands, path)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "replaceTextAllFilesRecursivelyNamed",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def deleteAllFilesRecursivelyFinishing(path : String, extensions = Array(String).new)
            extensionCommands = String.new

            extensions.each do |extension|
                extensionCommands += ("-name ")
                extensionCommands += ("\\*.#{extension} ")
            end

            requestedCommands = <<-CMD
                                find #{path} #{extensionCommands} -delete
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "deleteAllFilesRecursivelyFinishing",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def makeLink(target : String, path : String, type : Symbol)
            command = String.new

            case type
            when :hardLink
                command = "ln"
            when :symbolicLink
                command = "ln -s"
            when :symbolicLinkByOverwrite
                symlinkRealPath = (Ism.targetSystemInformation.handleChroot ? "#{Ism.settings.rootPath}/#{path}" : "/#{path}")

                if File.symlink?(symlinkRealPath)
                    deleteFileNoChroot(symlinkRealPath)
                end

                command = "ln -sf"
            else
                Ism.notifyOfMakeLinkUnknowTypeError(target, path, type)
                Ism.exitProgram
            end

            requestedCommands = "#{command} '#{target}' #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def generateEmptyFile(path : String)
            requestedCommands = "touch #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "generateEmptyFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def copyFile(path : String, targetPath : String)
            requestedCommands = "cp #{path} #{targetPath}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "copyFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def copyDirectory(path : String, targetPath : String)
            requestedCommands = "cp -r #{path} #{targetPath}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "copyDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def moveFile(path : String, newPath : String)
            requestedCommands = "mv #{path} #{newPath}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "moveFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def makeDirectory(path : String)
            requestedCommands = "mkdir -p #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "makeDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def deleteDirectory(path : String)
            requestedCommands = "rm -r #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "deleteDirectory",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def deleteFile(path : String)
            requestedCommands = "rm #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "deleteFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runChmodCommand(arguments = String.new)
            requestedCommands = "chmod #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runChmodCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runChownCommand(arguments = String.new)
            requestedCommands = "chown #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runChownCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runUserAddCommand(arguments : String)
            requestedCommands = "useradd -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true,
                                            viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Error.show(className: "Software",
                                functionName: "runUserAddCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runUserDelCommand(arguments : String)
            requestedCommands = "userdel -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true,
                                            viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Error.show(className: "Software",
                                functionName: "runUserDelCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGroupAddCommand(arguments : String)
            requestedCommands = "groupadd -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true,
                                            viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Error.show(className: "Software",
                                functionName: "runGroupAddCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGroupDelCommand(arguments : String)
            requestedCommands = "groupdel -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true,
                                            viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Error.show(className: "Software",
                                functionName: "runGroupDelCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runFile(file : String, arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            Ism.runFile(file, arguments, path, environment, environmentFilePath)
        end

        def runTarCommand(arguments = String.new, path = String.new)
            requestedCommands = "tar #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runTarCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runPythonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, version = String.new)
            requestedCommands = "python#{version} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runPythonCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runPipCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, version = String.new)
            requestedCommands = "pip#{version} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runPipCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runCrystalCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "CRYSTAL_WORKERS=#{Ism.settings.systemMakeOptions[2..-1]} crystal #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runCrystalCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runCmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.targetSystemInformation.handleChroot

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.chrootBuildOptions : buildOptions}"
                end
            else

                if !environment.has_key?("CFLAGS")
                    environment["CFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end

                if !environment.has_key?("CXXFLAGS")
                    environment["CXXFLAGS"] = "#{buildOptions == "" ? Ism.settings.systemBuildOptions : buildOptions}"
                end
            end

            requestedCommands = "cmake #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runCmakeCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runQmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "qmake #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runQmakeCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runMesonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "meson #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runMesonCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runNinjaCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.targetSystemInformation.handleChroot
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

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runNinjaCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runPwconvCommand(arguments = String.new)
            requestedCommands = "pwconv #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runPwconvCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGrpconvCommand(arguments = String.new)
            requestedCommands = "grpconv #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGrpconvCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runUdevadmCommand(arguments : String)
            requestedCommands = "udevadm #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runUdevadmCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runDbusUuidgenCommand(arguments = String.new)
            requestedCommands = "dbus-uuidgen #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runDbusUuidgenCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runMakeinfoCommand(arguments : String, path = String.new)
            requestedCommands = "makeinfo #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runMakeinfoCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runInstallInfoCommand(arguments : String)
            requestedCommands = "install-info #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runInstallInfoCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runAutoconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoconf #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runAutoconfCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runAutoreconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoreconf #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runAutoreconfCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runLocaledefCommand(arguments : String)
            requestedCommands = "localedef #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runLocaledefCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGunzipCommand(arguments : String, path = String.new)
            requestedCommands = "gunzip #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGunzipCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runMakeCaCommand(arguments : String)
            requestedCommands = "make-ca #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runMakeCaCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runInstallCatalogCommand(arguments : String)
            requestedCommands = "install-catalog #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runInstallCatalogCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runXmlCatalogCommand(arguments : String)
            requestedCommands = "xmlcatalog #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runXmlCatalogCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runLdconfigCommand(arguments = String.new)
            requestedCommands = "ldconfig #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runLdconfigCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGtkQueryImmodules2Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-2.0 #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGtkQueryImmodules2Command",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGtkQueryImmodules3Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-3.0 #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGtkQueryImmodules3Command",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGlibCompileSchemasCommand(arguments = String.new)
            requestedCommands = "glib-compile-schemas #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGlibCompileSchemasCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGdkPixbufQueryLoadersCommand(arguments = String.new)
            requestedCommands = "gdk-pixbuf-query-loaders #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGdkPixbufQueryLoadersCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runUpdateMimeDatabaseCommand(arguments = String.new)
            requestedCommands = "update-mime-database #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runUpdateMimeDatabaseCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runCargoCommand(arguments : String, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "cargo #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runCargoCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runXargoCommand(arguments : String, path = String.new)
            requestedCommands = "xargo #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runXargoCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGccCommand(arguments = String.new, path = String.new)
            requestedCommands = "gcc #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGccCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runRcUpdateCommand(arguments = String.new)
            requestedCommands = "rc-update #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runRcUpdateCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runAlsactlCommand(arguments = String.new)
            requestedCommands = "alsactl #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runAlsactlCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runGtkUpdateIconCacheCommand(arguments = String.new)
            requestedCommands = "gtk-update-icon-cache #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runGtkUpdateIconCacheCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runUpdateDesktopDatabaseCommand(arguments = String.new)
            requestedCommands = "update-desktop-database #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runUpdateDesktopDatabaseCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runZicCommand(arguments : String, path = String.new)
            requestedCommands = "zic #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            path: path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runZicCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def prepareOpenrcServiceInstallation(path : String, name : String)
            servicesPath = "/etc/init.d/"

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")
            moveFile(path,"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}#{name}")
            runChmodCommand("+x #{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}#{name}")

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "prepareOpenrcServiceInstallation",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def configure
            Ism.notifyOfConfigure(@information)
        end

        def configureSource(arguments = String.new, path = String.new, configureDirectory = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, relatedToMainBuild = true)
            configureCommand = "#{@buildDirectory && relatedToMainBuild ? ".." : "."}/#{configureDirectory}/configure"

            requestedCommands = "#{configureCommand} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "configureSource",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end
        
        def build
            Ism.notifyOfBuild(@information)
        end

        def makePerlSource(path = String.new)
            requestedCommands = "perl Makefile.PL"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "makePerlSource",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runCpanCommand(arguments = String.new)
            requestedCommands = "cpan #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runCpanCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runDircolorsCommand(arguments = String.new)
            requestedCommands = "dircolors #{arguments}"

            process = Ism.runSystemCommand( command: requestedCommands,
                                            asRoot: true)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runDircolorsCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runDepmodCommand(arguments = String.new)
            requestedCommands = "depmod #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runDepmodCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def runSshKeygenCommand(arguments = String.new)
            requestedCommands = "ssh-keygen #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "runSshKeygenCommand",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
            end
        end

        def makeSource(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.targetSystemInformation.handleChroot
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

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Error.show(className: "Software",
                                functionName: "makeSource",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function")
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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "recordInstallationInformation",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def updateSystemCache
            Ism.notifyOfUpdateSystemCache

            if commandIsAvailable("ldconfig") && Ism.targetSystemInformation.handleChroot
                runLdconfigCommand
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "updateSystemCache",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def deploy
            Ism.notifyOfDeploy
        end

        #Special function for the installation process without chroot (Internal use only)
        def installFile(target : String, path : String, user : String, group : String, mode : String) : Process::Status


            #TEMPORARY DISABLED UNTIL SECURITYMAP ARE SET PROPERLY
            # changeFileModeNoChroot(path, mode, asRoot: true)
            # changeFileOwnerNoChroot(path, user, group, asRoot: true)
            condition = (Ism.targetSystemInformation.handleChroot || !Ism.targetSystemInformation.handleChroot && Ism.settings.rootPath == "/")

            Ism.runAsSuperUser(validCondition: condition) {
                moveFileNoChroot(target,path)
            }

            rescue exception
            ISM::Error.show(className: "Software",
                            functionName: "installFile",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end

        #Special function for the installation process without chroot (Internal use only)
        def installDirectory(path : String, user : String, group : String, mode : String) : Process::Status

            #TEMPORARY DISABLED UNTIL SECURITYMAP ARE SET PROPERLY
            # changeFileModeNoChroot(path, mode, asRoot: true)
            # changeFileOwnerNoChroot(path, user, group, asRoot: true)
            condition = (Ism.targetSystemInformation.handleChroot || !Ism.targetSystemInformation.handleChroot && Ism.settings.rootPath == "/")

            Ism.runAsSuperUser(validCondition: condition) {
                makeDirectoryNoChroot(path)
            }

            rescue exception
            ISM::Error.show(className: "Software",
                            functionName: "installDirectory",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end

        #Special function for the installation process without chroot (Internal use only)
        def installSymlink(target : String, path : String) : Process::Status
            condition = (Ism.targetSystemInformation.handleChroot || !Ism.targetSystemInformation.handleChroot && Ism.settings.rootPath == "/")

            Ism.runAsSuperUser(validCondition: condition) {
                moveFileNoChroot(target,path)
            }

            rescue exception
            ISM::Error.show(className: "Software",
                            functionName: "installSymlink",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def stripFileListNoChroot(fileList : Array(String))
            requestedCommands = <<-CMD
            strip --strip-unneeded #{fileList.join("\" || true\nstrip --strip-unneeded \"")} || true
            CMD

            process = Process.run(requestedCommands, shell: true)

            #No exit process because if the file can't be strip, we can just keep going
            rescue
        end

        def install(preserveLibtoolArchives = false, stripFiles = true)
            Ism.notifyOfInstall(@information)

            if Ism.targetSystemInformation.handleChroot
                Ism.unlockSystemAccess
            end

            fileList = Dir.glob(["#{builtSoftwareDirectoryPathNoChroot}/**/*"], match: :dot_files)
            installedFiles = Array(String).new

            fileList.each do |entry|

                #Don't keep libtool archives by default except if explicitely specified
                if File.directory?(entry) || entry[-3..-1] != ".la" || preserveLibtoolArchives

                    finalDestination = "/#{entry.sub(builtSoftwareDirectoryPathNoChroot,"")}"
                    recordedFilePath = "/#{finalDestination.sub(Ism.settings.rootPath,"")}".squeeze("/")

                    if !File.exists?(finalDestination) || Ism.softwareIsInstalled(@information) && ISM::SoftwareInformation.loadConfiguration(@information.installedFilePath).installedFiles.includes?(recordedFilePath)
                        installedFiles << recordedFilePath
                    end

                    securityDescriptor = @information.securityMap.descriptor(   path:  recordedFilePath,
                                                                                realPath:   entry)

                    if File.directory?(entry) && !File.symlink?(entry)
                        if !Dir.exists?(finalDestination)
                            installDirectory(   path:   finalDestination,
                                                user:   securityDescriptor.user,
                                                group:  securityDescriptor.group,
                                                mode:   securityDescriptor.mode)
                        end
                    else
                        if File.symlink?(entry)
                            installSymlink( target: entry,
                                            path:   finalDestination)
                        else
                            installFile(target: entry,
                                        path:   finalDestination,
                                        user:   securityDescriptor.user,
                                        group:  securityDescriptor.group,
                                        mode:   securityDescriptor.mode)
                        end
                    end

                end
            end

            #Strip the file if needed
            if stripFiles
                stripFileListNoChroot(fileList)
            end

            #Update library cache
            updateSystemCache

            #Run post installation process
            deploy

            if Ism.softwareIsRequestedSoftware(@information, Ism.requestedSoftwares.map { |entry| entry.fullVersionName}) && !Ism.softwareIsInstalled(@information)
                Ism.addSoftwareToFavouriteGroup(@information.fullVersionName)
            end

            Ism.addInstalledSoftware(@information, installedFiles)

            if Ism.targetSystemInformation.handleChroot
                Ism.lockSystemAccess
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "install",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def kernelSourcesPath : String
            return Ism.kernelSourcesPath
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

        #Return an array splitted, except when there are conditions between parenthesis
        def getConditionArray(conditions : String) : Array(String)
            parenthesisArray = conditions.scan(/(!?\(.*?\))/)

            parenthesisArray.each do |old|
                new = old.to_s.gsub(" && ","&&")
                new = new.gsub(" || ","||")

                conditions = conditions.gsub(old.to_s,new)
            end

            return conditions.split(" && ")

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "getConditionArray",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "parseKconfigConditions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
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

                        mainArchitecture = (Ism.targetSystemInformation.handleChroot ? Ism.settings.chrootArchitecture : Ism.settings.systemArchitecture).gsub(/_.*/,"")

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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "getFullKernelKconfigFile",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "generateKernelOptionsFiles",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def updateKernelOptionsDatabase
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

        def recordNeededKernelOptions
            Ism.notifyOfRecordNeededKernelOptions
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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "cleanWorkDirectoryPath",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def showInformations
            puts
            Ism.printInformationNotificationTitle(@information.name,@information.version)
        end

        def uninstall
            Ism.notifyOfUninstall(@information)

            Ism.uninstallSoftware(@information)
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

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "dependency",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def isGreatestVersion : Bool
            return Ism.softwareIsGreatestVersion(@information)
        end

        def majorVersion : Int32
            return SemanticVersion.parse(@information.version).major
        end

        def minorVersion : Int32
            return SemanticVersion.parse(@information.version).minor
        end

        def patchVersion : Int32
            return SemanticVersion.parse(@information.version).patch
        end

        #Internal use only
        def dependencyVersion(fullName : String) : SemanticVersion
            return SemanticVersion.parse(dependency(fullName).version)
        end

        #Internal use only
        def dependencyMajorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).major
        end

        #Internal use only
        def dependencyMinorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).minor
        end

        #Internal use only
        def dependencyPatchVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).patch
        end

        def softwareVersion(fullName : String) : SemanticVersion
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version)
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "softwareVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareMajorVersion(fullName : String) : Int32
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyMajorVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).major
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "softwareMajorVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareMinorVersion(fullName : String) : Int32
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyMinorVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).minor
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "softwareMinorVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwarePatchVersion(fullName : String) : Int32
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyPatchVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).patch
            end

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "softwarePatchVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def softwareIsInstalled(softwareName : String) : Bool
            return Ism.softwareAnyVersionInstalled(softwareName)
        end

        def architecture(architecture : String) : Bool
            return Ism.settings.systemArchitecture == architecture
        end

        def selectedKernel : ISM::SoftwareInformation
            return Ism.selectedKernel
        end

        def kernelSelected : Bool
            return selectedKernel.isValid
        end

        def isCurrentKernel : Bool
            return selectedKernel.versionName == @information.versionName
        end

        def showInfo(message : String)
            Ism.printInformationNotification(message)
        end

        def showInfoCode(message : String)
            Ism.printInformationCodeNotification(message)
        end

        def commandIsAvailable(command : String) : Bool
            process = Ism.runSystemCommand("type #{command} > /dev/null 2>&1")

            return (process.exit_code == 0)

            rescue exception
                ISM::Error.show(className: "Software",
                                functionName: "commandIsAvailable",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
