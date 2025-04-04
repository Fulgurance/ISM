module ISM

    class Software

        property information : ISM::SoftwareInformation
        property mainSourceDirectoryName : String
        property buildDirectory : Bool
        property buildDirectoryNames : Hash(String,String)
        property additions : Array(String)

        #Alias
        def recordCrossToolchainAsFullyBuilt
            Ism.systemInformation.setCrossToolchainFullyBuilt(true)
        end

        #Alias
        def recordSystemHandleUserAccess
            Ism.systemInformation.setHandleUserAccess(true)
        end

        #Alias
        def systemId : String
            return Ism.systemId
        end

        #Alias
        def systemHandleUserAccess : Bool
            return Ism.systemInformation.handleUserAccess
        end

        #Alias
        def enableInstallationByChroot
            Ism.settings.setInstallByChroot(true)
        end

        #Alias
        def version : String
            return @information.version
        end

        #Alias
        def name : String
            return @information.name
        end

        #Alias
        def versionName : String
            return @information.versionName
        end

        #Alias
        def passEnabled : Bool
            return @information.passEnabled
        end

        #Alias
        def mainKernelHeadersName : String
            return Ism.mainKernelHeadersName
        end

        #Alias
        def mainKernelName : String
            return Ism.mainKernelName
        end

        #Alias
        def mainKernelVersion : String
            return Ism.mainKernelVersion
        end

        #Alias
        def selectedKernel
            return Ism.selectedKernel
        end

        #Alias
        def kernelIsSelected
            return Ism.kernelIsSelected
        end

        #Alias
        def selectedKernel : ISM::SoftwareInformation
            return Ism.selectedKernel
        end

        def initialize(informationPath : String)
            @information = ISM::SoftwareInformation.loadConfiguration(informationPath)
            @mainSourceDirectoryName = ISM::Default::Software::SourcesDirectoryName
            @buildDirectory = false
            @buildDirectoryNames = { ISM::Default::Software::MainBuildDirectoryEntry => "mainBuild" }
            @additions = Array(String).new
        end

        # Internal use only
        def prepareChrootDevConsole
            requestedCommands = "mknod -m 600 #{Ism.settings.rootPath}/dev/console c 5 1"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootDevNull
            requestedCommands = "mknod -m 666 #{Ism.settings.rootPath}/dev/null c 1 3"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootDev
            requestedCommands = "mount --bind /dev #{Ism.settings.rootPath}/dev"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootDevPts
            requestedCommands = "mount --bind /dev/pts  #{Ism.settings.rootPath}/dev/pts"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootProc
            requestedCommands = "mount -t proc proc #{Ism.settings.rootPath}/proc"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootSysfs
            requestedCommands = "mount -t sysfs sysfs #{Ism.settings.rootPath}/sys"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootNetworkConfiguration
            requestedCommands = "cp /etc/resolv.conf #{Ism.settings.rootPath}/etc/resolv.conf"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        # Internal use only
        def prepareChrootFileSystem
            prepareChrootDevConsole
            prepareChrootDevNull
            prepareChrootDev
            prepareChrootDevPts
            prepareChrootProc
            prepareChrootSysfs
            prepareChrootNetworkConfiguration
        end

        # Internal use only
        def prepareRootPermissions
            binary = "chown"
            unlockTask = "chattr -f -i #{Ism.settings.rootPath}#{ISM::Default::Filename::Task}"
            setRoot = "#{binary} -R root:root #{Ism.settings.rootPath}"
            setVarIsm = "#{binary} -R ism:ism #{Ism.settings.rootPath}/var/ism"
            setEtcIsm = "#{binary} -R ism:ism #{Ism.settings.rootPath}/etc/ism"
            setVarLogIsm = "#{binary} -R ism:ism #{Ism.settings.rootPath}/var/log/ism"
            setTmpIsm = "#{binary} -R ism:ism #{Ism.settings.rootPath}/tmp/ism"
            setSources = "#{binary} -R ism:ism #{Ism.settings.sourcesPath}"
            lockTask = "chattr -f +i #{Ism.settings.rootPath}#{ISM::Default::Filename::Task}"

            requestedCommands = "#{unlockTask} && #{setRoot} && #{setVarIsm} && #{setEtcIsm} && #{setVarLogIsm} && #{setTmpIsm} && #{setSources} && #{lockTask}"

            process = Ism.runSystemCommand( requestedCommands,
                                            shell:  true,
                                            chroot: false,
                                            asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def userConfigurationFilePathNoChroot : String
            return "#{Ism.settings.rootPath}/etc/#{ISM::Default::Filename::UserConfiguration}"
        end

        #Special function to improve performance (Internal use only)
        def groupConfigurationFilePathNoChroot : String
            return "#{Ism.settings.rootPath}/etc/#{ISM::Default::Filename::GroupConfiguration}"
        end

        #Special function to improve performance (Internal use only)
        def getUserId(name : String) : String
            if File.exists?(userConfigurationFilePathNoChroot)
                configFile = File.read_lines(userConfigurationFilePathNoChroot)

                configFile.each do |line|
                    if line.starts_with?(name.downcase)
                        return line.split(":")[2]
                    end
                end
            else
                begin
                    #Small hack to check if the string contain a valid number
                    return name.to_i.to_s
                rescue
                end
            end

            return String.new

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def getGroupId(name : String) : String
            if File.exists?(groupConfigurationFilePathNoChroot)
                configFile = File.read_lines(groupConfigurationFilePathNoChroot)

                configFile.each do |line|
                    if line.starts_with?(name.downcase)
                        return line.split(":")[2]
                    end
                end
            else
                begin
                    #Small hack to check if the string contain a valid number
                    return name.to_i.to_s
                rescue
                end
            end

            return String.new

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        # def changeFileModeNoChroot(path : String, mode : String)
        #     File.chmod(path, mode.to_i(base: 8))
        #
        #     rescue error
        #         Ism.printSystemCallErrorNotification(error)
        #         Ism.exitProgram
        # end
        #
        # #Special function to improve performance (Internal use only)
        # def changeFileOwnerNoChroot(path : String, user : String, group : String)
        #     File.chown(path, getUserId(user).to_i, getGroupId(group).to_i)
        #
        #     rescue error
        #         Ism.printSystemCallErrorNotification(error)
        #         Ism.exitProgram
        # end

        #Special function to improve performance (Internal use only)
        def changeFileModeNoChroot(path : String, mode : String, asRoot = false)
            requestedCommands = "/usr/bin/chmod #{mode} #{path}"

            process = Ism.runSystemCommand(requestedCommands, shell: false, asRoot: asRoot)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def changeFileOwnerNoChroot(path : String, user : String, group : String, asRoot = false)
            requestedCommands = "/usr/bin/chown #{user}:#{group} #{path}"

            process = Ism.runSystemCommand(requestedCommands, shell: false, asRoot: asRoot)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        #Special function to improve performance (Internal use only)
        def workDirectoryPathNoChroot : String
            return Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def mainWorkDirectoryPathNoChroot : String
            return workDirectoryPathNoChroot+"/"+@mainSourceDirectoryName

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def buildDirectoryPathNoChroot(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPathNoChroot+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def builtSoftwareDirectoryPathNoChroot : String
            return "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def workDirectoryPath : String
            return Ism.settings.installByChroot ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.port+"/"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def mainWorkDirectoryPath : String
            return workDirectoryPath+"/"+@mainSourceDirectoryName

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def buildDirectoryPath(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPath+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def builtSoftwareDirectoryPath : String
            return Ism.settings.installByChroot ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def directoryContent(path : String, matchHidden = false) : Array(String)
            path = "#{path}/*"

            fileList = Dir.glob((Ism.settings.installByChroot ? Ism.settings.rootPath+path : path), match: (matchHidden ? File::MatchOptions.glob_default : File::MatchOptions::None))

            return fileList.map { |file| (Ism.settings.installByChroot ? file[(Ism.settings.rootPath.size-1)..-1] : file)}

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def downloadAdditions
            Ism.notifyOfDownloadAdditions

            downloadAdditionalSources
            downloadAdditionalSourcesSha512
        end

        def downloadAdditionalSources
            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")]).gsub(ISM::Default::Software::ArchiveExtensionName,"")

                downloadFile(   link,
                                archiveName,
                                ISM::Default::Software::ArchiveExtensionName)
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def downloadAdditionalSourcesSha512
            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")]).gsub(ISM::Default::Software::ArchiveExtensionName,"")
                sha512Link = "#{link.gsub(ISM::Default::Software::ArchiveExtensionName,"")}#{ISM::Default::Software::ArchiveSha512ExtensionName}"

                downloadFile(   sha512Link,
                                archiveName,
                                ISM::Default::Software::ArchiveSha512ExtensionName)
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def downloadSources
            downloadFile(   @information.sourcesLink,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveExtensionName)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def downloadSourcesSha512
            downloadFile(   @information.sourcesSha512Link,
                            ISM::Default::Software::SourcesArchiveBaseName,
                            ISM::Default::Software::ArchiveSha512ExtensionName)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end
        
        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            rescue error
                Ism.notifyOfGetFileContentError(filePath, error)
                Ism.exitProgram
            end
            return content

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def check
            Ism.notifyOfCheck(@information)

            checkSourcesSha512

            if !@additions.empty?
                checkAdditionsSha512
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def checkSourcesSha512
            checkFile(  archive:    "#{workDirectoryPathNoChroot}/#{ISM::Default::Software::SourcesArchiveName}",
                        sha512:     getFileContent(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesSha512ArchiveName).strip)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def checkAdditionsSha512
            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")]).gsub(ISM::Default::Software::ArchiveExtensionName,"")

                checkFile(  archive:    "#{workDirectoryPathNoChroot}/#{archiveName}#{ISM::Default::Software::ArchiveExtensionName}",
                            sha512:     getFileContent("#{workDirectoryPathNoChroot}/#{archiveName}#{ISM::Default::Software::ArchiveSha512ExtensionName}").strip)
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def checkFile(archive : String, sha512 : String)
            digest = Digest::SHA512.new
            digest.file(archive)
            archiveSha512 = digest.hexfinal

            if archiveSha512 != sha512
                Ism.notifyOfCheckError(archive, sha512)
                Ism.exitProgram
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def extractSources
            extractArchive(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesArchiveName, workDirectoryPathNoChroot)
            moveFileNoChroot(workDirectoryPathNoChroot+"/"+@information.versionName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesDirectoryName)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def extractAdditions
            Ism.notifyOfExtractAdditions

            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")])

                extractArchive("#{workDirectoryPathNoChroot}/#{archiveName}", workDirectoryPathNoChroot)
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def extractArchive(archivePath : String, destinationPath = workDirectoryPathNoChroot)
            process = Ism.runSystemCommand( "/usr/bin/tar -xf #{archivePath}",
                                            quiet: true,
                                            shell: false,
                                            chroot: false,
                                            path: destinationPath)
            if !process.success?
                Ism.notifyOfExtractError(archivePath, destinationPath)
                Ism.exitProgram
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end
        
        def applyPatch(patch : String)
            process = Ism.runSystemCommand( "/usr/bin/patch -Np1 -i #{patch}",
                                            shell: false,
                                            chroot: false,
                                            path: mainWorkDirectoryPathNoChroot)
            if !process.success?
                Ism.notifyOfApplyPatchError(patch)
                Ism.exitProgram
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def prepare
            Ism.notifyOfPrepare(@information)

            #Generate all build directories
            @buildDirectoryNames.keys.each do |key|
                if !Dir.exists?(buildDirectoryPathNoChroot(key))
                    makeDirectoryNoChroot(buildDirectoryPathNoChroot(key))
                end
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def copyFileNoChroot(path : String, targetPath : String, asRoot = false)
            Ism.runAsSuperUser(validCondition: asRoot) {
                FileUtils.cp(path, targetPath)
            }

            rescue error
                Ism.notifyOfCopyFileError(path, targetPath, error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def copyDirectoryNoChroot(path : String, targetPath : String, asRoot = false)
            Ism.runAsSuperUser(validCondition: asRoot) {
                FileUtils.cp_r(path, targetPath)
            }

            rescue error
                Ism.notifyOfCopyDirectoryError(path, targetPath, error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def deleteFileNoChroot(path : String, asRoot = false)
            Ism.runAsSuperUser(validCondition: asRoot) {
                FileUtils.rm(path)
            }

            rescue error
                Ism.notifyOfDeleteFileError(path, error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def moveFileNoChroot(path : String, newPath : String, asRoot = false)
            Ism.runAsSuperUser(validCondition: asRoot) {
                FileUtils.mv(path, newPath)
            }

            rescue error
                Ism.notifyOfMoveFileError(path, newPath, error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def makeDirectoryNoChroot(directory : String, asRoot = false)
            Ism.runAsSuperUser(validCondition: asRoot) {
                FileUtils.mkdir_p(directory)
            }

            rescue error
                Ism.notifyOfMakeDirectoryError(directory, error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def deleteDirectoryNoChroot(directory : String, asRoot = false)
            Ism.runAsSuperUser(validCondition: asRoot) {
                FileUtils.rm_r(directory)
            }

            rescue error
                Ism.notifyOfDeleteDirectoryError(directory, error)
                Ism.exitProgram
        end

        def fileUpdateContent(path : String, data : String)
            requestedCommands = <<-CMD
                                grep -q '#{data}' '#{path}' || echo "#{data}" >> '#{path}'
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceText(path : String, text : String, newText : String)
            requestedCommands = <<-CMD
                                sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/g' #{path}
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceLineContaining(path : String, text : String, newLine : String)
            requestedCommands = <<-CMD
                                sed -i '/#{text.gsub(/([\.\/])/, %q(\\\1))}/c\#{newText.gsub(/([\.\/])/, %q(\\\1))}' #{path}
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileReplaceTextAtLineNumber(path : String, text : String, newText : String,lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}s/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' #{path}
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileDeleteLine(path : String, lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}d' #{path}
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

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

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileAppendData(path : String, data : String)
            requestedCommands = <<-CMD
                                echo "#{data}" > "#{path}"
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def fileAppendDataFromFile(path : String, fromPath : String)
            requestedCommands = <<-CMD
                                cat "#{fromPath}" >> "#{path}"
                                CMD

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            requestedCommands = <<-CMD
                                find -name #{filename} -exec sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' {} \\;
                                CMD

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
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
                symlinkRealPath = (Ism.settings.installByChroot ? "#{Ism.settings.rootPath}/#{path}" : "/#{path}")

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
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def generateEmptyPasswdFile
            requestedCommands = "touch /usr/bin/passwd"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def copyFile(path : String, targetPath : String)
            requestedCommands = "cp #{path} #{targetPath}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def copyDirectory(path : String, targetPath : String)
            requestedCommands = "cp -r #{path} #{targetPath}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def moveFile(path : String, newPath : String)
            requestedCommands = "mv #{path} #{newPath}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def makeDirectory(path : String)
            requestedCommands = "mkdir -p #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def deleteDirectory(path : String)
            requestedCommands = "rm -r #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def deleteFile(path : String)
            requestedCommands = "rm #{path}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runChmodCommand(arguments = String.new, path = String.new)
            requestedCommands = "chmod #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runChownCommand(arguments = String.new, path = String.new)
            requestedCommands = "chown #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runUserAddCommand(arguments : String)
            requestedCommands = "useradd -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, shell: true, asRoot: true)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUserDelCommand(arguments : String)
            requestedCommands = "userdel -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, shell: true, asRoot: true)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGroupAddCommand(arguments : String)
            requestedCommands = "groupadd -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, shell: true, asRoot: true)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGroupDelCommand(arguments : String)
            requestedCommands = "groupdel -R #{Ism.settings.rootPath} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, shell: true, asRoot: true)

            if !process.success? && process.exit_code != 9
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runFile(file : String, arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "./#{file} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runTarCommand(arguments = String.new, path = String.new)
            requestedCommands = "tar #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runPythonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, version = String.new)
            requestedCommands = "python#{version} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runPipCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, version = String.new)
            requestedCommands = "pip#{version} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runCrystalCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "CRYSTAL_WORKERS=#{Ism.settings.systemMakeOptions[2..-1]} crystal #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runCmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, makeOptions = String.new, buildOptions = String.new)

            if Ism.settings.installByChroot

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
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runQmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "qmake #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runMesonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "meson #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

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

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runPwconvCommand(arguments = String.new)
            requestedCommands = "pwconv #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGrpconvCommand(arguments = String.new)
            requestedCommands = "grpconv #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUdevadmCommand(arguments : String)
            requestedCommands = "udevadm #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runDbusUuidgenCommand(arguments = String.new)
            requestedCommands = "dbus-uuidgen #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runMakeinfoCommand(arguments : String, path = String.new)
            requestedCommands = "makeinfo #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runInstallInfoCommand(arguments : String)
            requestedCommands = "install-info #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runAutoconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoconf #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runAutoreconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoreconf #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def runLocaledefCommand(arguments : String)
            requestedCommands = "localedef #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGunzipCommand(arguments : String, path = String.new)
            requestedCommands = "gunzip #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runMakeCaCommand(arguments : String)
            requestedCommands = "make-ca #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runInstallCatalogCommand(arguments : String)
            requestedCommands = "install-catalog #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runXmlCatalogCommand(arguments : String)
            requestedCommands = "xmlcatalog #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runLdconfigCommand(arguments = String.new)
            requestedCommands = "ldconfig #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGtkQueryImmodules2Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-2.0 #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGtkQueryImmodules3Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-3.0 #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGlibCompileSchemasCommand(arguments = String.new)
            requestedCommands = "glib-compile-schemas #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGdkPixbufQueryLoadersCommand(arguments = String.new)
            requestedCommands = "gdk-pixbuf-query-loaders #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUpdateMimeDatabaseCommand(arguments = String.new)
            requestedCommands = "update-mime-database #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runCargoCommand(arguments : String, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "cargo #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment)
                Ism.exitProgram
            end
        end

        def runXargoCommand(arguments : String, path = String.new)
            requestedCommands = "xargo #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runGccCommand(arguments = String.new, path = String.new)
            requestedCommands = "gcc #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path)
                Ism.exitProgram
            end
        end

        def runRcUpdateCommand(arguments = String.new)
            requestedCommands = "rc-update #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runAlsactlCommand(arguments = String.new)
            requestedCommands = "alsactl #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runGtkUpdateIconCacheCommand(arguments = String.new)
            requestedCommands = "gtk-update-icon-cache #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runUpdateDesktopDatabaseCommand(arguments = String.new)
            requestedCommands = "update-desktop-database #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runZicCommand(arguments : String, path = String.new)
            requestedCommands = "zic #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, asRoot: true)

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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def configure
            Ism.notifyOfConfigure(@information)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def configureSource(arguments = String.new, path = String.new, configureDirectory = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, relatedToMainBuild = true)
            configureCommand = "#{@buildDirectory && relatedToMainBuild ? ".." : "."}/#{configureDirectory}/configure"

            requestedCommands = "#{configureCommand} #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

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

            process = Ism.runSystemCommand(requestedCommands, path)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runCpanCommand(arguments = String.new)
            requestedCommands = "cpan #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runDircolorsCommand(arguments = String.new)
            requestedCommands = "dircolors #{arguments}"

            process = Ism.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runDepmodCommand(arguments = String.new)
            requestedCommands = "depmod #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
                Ism.exitProgram
            end
        end

        def runSshKeygenCommand(arguments = String.new)
            requestedCommands = "ssh-keygen #{arguments}"

            process = Ism.runSystemCommand(requestedCommands)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands)
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

            process = Ism.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                Ism.notifyOfRunSystemCommandError(requestedCommands, path, environment, environmentFilePath)
                Ism.exitProgram
            end
        end

        def prepareInstallation
            Ism.notifyOfPrepareInstallation(@information)
        end

        def recordInstallationInformation : Tuple(UInt128, UInt128, UInt128, UInt128)
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function to improve performance (Internal use only)
        def stripFileListNoChroot(fileList : Array(String))
            path = "#{Ism.settings.rootPath}#{ISM::Default::Filename::StrippingList}"

            if File.exists?(path)
                Ism.runAsSuperUser {
                    deleteFileNoChroot(path)
                }
            end

            data = fileList.join("\n")
            requestedCommands = "/usr/bin/xargs --arg-file=\'#{path}\' /usr/bin/strip --strip-unneeded || true"

            File.write(path, data)

            process = Ism.runSystemCommand(requestedCommands, quiet: true, shell: false, asRoot: systemHandleUserAccess)

            #No exit process because if the file can't be strip, we can just keep going
            rescue
        end

        #Special function for the installation process without chroot (Internal use only)
        def installFile(target : String, path : String, user : String, group : String, mode : String)
            moveFileNoChroot(target, path, asRoot: systemHandleUserAccess)
            #TEMPORARY DISABLED UNTIL SECURITYMAP ARE SET PROPERLY
            # changeFileModeNoChroot(path, mode, asRoot: true)
            # changeFileOwnerNoChroot(path, user, group, asRoot: true)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function for the installation process without chroot (Internal use only)
        def installDirectory(path : String, user : String, group : String, mode : String)
            makeDirectoryNoChroot(path, asRoot: systemHandleUserAccess)
            #TEMPORARY DISABLED UNTIL SECURITYMAP ARE SET PROPERLY
            # changeFileModeNoChroot(path, mode, asRoot: true)
            # changeFileOwnerNoChroot(path, user, group, asRoot: true)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function for the installation process without chroot (Internal use only)
        def installSymlink(target : String, path : String)
            moveFileNoChroot(target, path, asRoot: systemHandleUserAccess)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function for the installation process (Internal use only)
        def updateSystemCache
            if commandIsAvailable("ldconfig") && systemHandleUserAccess
                runLdconfigCommand
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function for the uninstallation process without chroot (Internal use only)
        def uninstallFile(path : String)
            deleteFileNoChroot(path, asRoot: true)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Special function for the uninstallation process without chroot (Internal use only)
        def uninstallDirectory(path : String)
            deleteDirectoryNoChroot(path, asRoot: true)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Manage stripping, recording installed files and favourites, libtool archive removal, and mount/remount critical point with read-only/read-write access
        def install(preserveLibtoolArchives = false, stripFiles = true)
            Ism.notifyOfInstall(@information)

            if systemHandleUserAccess
                Ism.notifyOfUnlockingSystemAccess
                Ism.unlockSystemAccess

                #Special case when we are switching to the installation by chroot during cross toolchain construction
                if !Ism.settings.installByChroot && !Ism.systemInformation.crossToolchainFullyBuilt
                    prepareRootPermissions
                end

            end

            fileList = Dir.glob(["#{builtSoftwareDirectoryPathNoChroot}/**/*"], match: :dot_files)
            installedFiles = Array(String).new

            Ism.notifyOfApplyingSecurityMap

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
                        #TO DO: Pre check if files are the same
                        if !File.exists?(finalDestination)
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
            end

            #Strip the file if needed
            if stripFiles
                Ism.notifyOfStrippingFiles

                stripFileListNoChroot(  fileList:   fileList)
            end

            #Update library cache
            updateSystemCache

            #Run post installation process
            deploy

            if Ism.softwareIsRequestedSoftware(@information, Ism.requestedSoftwares.map { |entry| entry.fullVersionName}) && !Ism.softwareIsInstalled(@information)
                Ism.addSoftwareToFavouriteGroup(@information.fullVersionName)
            end

            Ism.addInstalledSoftware(@information, installedFiles)

            if systemHandleUserAccess
                Ism.notifyOfLockingSystemAccess
                Ism.lockSystemAccess
            end

            rescue error
                #We make sure the system is locked even an error occured
                if systemHandleUserAccess
                    Ism.lockSystemAccess
                end

                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def deploy
            Ism.notifyOfDeploy
        end

        def kernelSourcesPath : String
            return Ism.kernelSourcesPath

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def kernelSourcesArchitecturePath : String
            return "#{kernelSourcesPath}arch/"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def kernelKconfigFilePath : String
            return "#{kernelSourcesPath}Kconfig"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def kernelArchitectureKconfigFilePath : String
            return "#{kernelSourcesArchitecturePath}Kconfig"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def kernelConfigFilePath : String
            return "#{kernelSourcesPath}.config"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def kernelOptionsDatabasePath : String
            return "#{Ism.settings.rootPath}#{ISM::Default::Path::KernelOptionsDirectory}#{mainKernelName}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end
        
        def clean
            Ism.notifyOfClean(@information)

            cleanWorkDirectoryPath

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def cleanWorkDirectoryPath
            if Dir.exists?(workDirectoryPathNoChroot)
                deleteDirectoryNoChroot(workDirectoryPathNoChroot)
            end

            makeDirectoryNoChroot(workDirectoryPathNoChroot)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def showInformations
            puts
            Ism.printInformationNotificationTitle(@information.name,@information.version)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def uninstall
            Ism.notifyOfUninstall(@information)

            Ism.uninstallSoftware(@information)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def option(optionName : String) : Bool
            return @information.option(optionName)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def dependency(fullName : String) : ISM::SoftwareInformation
            @information.dependencies(unsorted: true).each do |entry|
                if entry.fullName == fullName
                    return entry.information
                end
            end

            return ISM::SoftwareInformation.new

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def isGreatestVersion : Bool
            return Ism.getSoftwareInformation(@information.fullName).version <= @information.version

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def majorVersion : Int32
            return SemanticVersion.parse(@information.version).major
        end

        def minorVersion : Int32
            return SemanticVersion.parse(@information.version).minor

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def patchVersion : Int32
            return SemanticVersion.parse(@information.version).patch

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Internal use only
        def dependencyVersion(fullName : String) : SemanticVersion
            return SemanticVersion.parse(dependency(fullName).version)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Internal use only
        def dependencyMajorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).major

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Internal use only
        def dependencyMinorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).minor

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Internal use only
        def dependencyPatchVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).patch

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def softwareVersion(fullName : String) : SemanticVersion
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version)
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def softwareMajorVersion(fullName : String) : Int32
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyMajorVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).major
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def softwareMinorVersion(fullName : String) : Int32
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyMinorVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).minor
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def softwarePatchVersion(fullName : String) : Int32
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyPatchVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version).patch
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def softwareIsInstalled(softwareName : String) : Bool
            return Ism.softwareAnyVersionInstalled(softwareName)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def architecture(architecture : String) : Bool
            return Ism.settings.systemArchitecture == architecture

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def kernelSelected : Bool
            return selectedKernel.isValid

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def isCurrentKernel : Bool
            return selectedKernel.versionName == @information.versionName

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def showInfo(message : String)
            Ism.printInformationNotification(message)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def showInfoCode(message : String)
            Ism.printInformationCodeNotification(message)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def commandIsAvailable(command : String) : Bool
            process = Ism.runSystemCommand("type #{command} > /dev/null 2>&1")

            return (process.exit_code == 0)

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
