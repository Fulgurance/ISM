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
            return ISM::Core::Security.systemHandleUserAccess
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
            return ISM::Core.mainKernelHeadersName
        end

        #Alias
        def mainKernelName : String
            return ISM::Core.mainKernelName
        end

        #Alias
        def mainKernelVersion : String
            return ISM::Core.mainKernelVersion
        end

        #Alias
        def kernelIsSelected
            return ISM::Core.kernelIsSelected
        end

        #Alias
        def selectedKernel : ISM::SoftwareInformation
            return ISM::Core.selectedKernel
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
            requestedCommands = "/usr/bin/mknod -m 600 #{Ism.settings.rootPath}/dev/console c 5 1"

            #TO DO
            # if !ISM::Core::Security.stillHaveSudoAccess
            #     ISM::Core::Notification.securityNotification(   command: requestedCommands,
            #                                                     reason: "",
            #                                                     details: String)
            # end

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootDevConsole",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootDevNull
            requestedCommands = "/usr/bin/mknod -m 666 #{Ism.settings.rootPath}/dev/null c 1 3"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootDevNull",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootDev
            requestedCommands = "/usr/bin/mount --bind /dev #{Ism.settings.rootPath}/dev"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootDev",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootDevPts
            requestedCommands = "/usr/bin/mount --bind /dev/pts  #{Ism.settings.rootPath}/dev/pts"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootDevPts",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootProc
            requestedCommands = "/usr/bin/mount -t proc proc #{Ism.settings.rootPath}/proc"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootProc",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootSysfs
            requestedCommands = "/usr/bin/mount -t sysfs sysfs #{Ism.settings.rootPath}/sys"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootSysfs",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        # Internal use only
        def prepareChrootNetworkConfiguration
            requestedCommands = "/usr/bin/cp /etc/resolv.conf #{Ism.settings.rootPath}/etc/resolv.conf"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "prepareChrootNetworkConfiguration",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
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

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "prepareChrootFileSystem",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        # Internal use only
        def prepareRootPermissions
            requestedCommands = "find #{Ism.settings.rootPath} ! -name 'ism' ! -name '.ISM*' ! -wholename '#{Ism.settings.sourcesPath}' ! -wholename '#{Ism.settings.toolsPath}' -exec chown root:root '{}' \;"

            process = ISM::Core.runSystemCommand(   requestedCommands,
                                                    viaChroot: false,
                                                    asRoot: true)

            if !process.success?
            # rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "prepareRootPermissions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def userConfigurationFilePathNoChroot : String
            return "#{Ism.settings.rootPath}/etc/#{ISM::Default::Filename::UserConfiguration}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "userConfigurationFilePathNoChroot",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def groupConfigurationFilePathNoChroot : String
            return "#{Ism.settings.rootPath}/etc/#{ISM::Default::Filename::GroupConfiguration}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "groupConfigurationFilePathNoChroot",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "getUserId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "getGroupId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def changeFileModeNoChroot(path : String, mode : String, asRoot = false)
            requestedCommands = "/usr/bin/chmod #{mode} #{path}"

            process = ISM::Core.runSystemCommand(   command: requestedCommands,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "changeFileModeNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def changeFileOwnerNoChroot(path : String, user : String, group : String, asRoot = false)
            requestedCommands = "/usr/bin/chown #{user}:#{group} #{path}"

            process = ISM::Core.runSystemCommand(   command: requestedCommands,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "changeFileOwnerNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def workDirectoryPathNoChroot : String
            return "#{Ism.settings.sourcesPath}#{@information.port}/#{@information.name}/#{@information.version}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "workDirectoryPathNoChroot",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def mainWorkDirectoryPathNoChroot : String
            return workDirectoryPathNoChroot+"/"+@mainSourceDirectoryName

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "mainWorkDirectoryPathNoChroot",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def buildDirectoryPathNoChroot(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPathNoChroot+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "buildDirectoryPathNoChroot",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def builtSoftwareDirectoryPathNoChroot : String
            return "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "builtSoftwareDirectoryPathNoChroot",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def workDirectoryPath : String
            return Ism.settings.installByChroot ? "/#{ISM::Default::Path::SourcesDirectory}"+@information.port+"/"+@information.name+"/"+@information.version : Ism.settings.sourcesPath+@information.port+"/"+@information.name+"/"+@information.version

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "workDirectoryPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def mainWorkDirectoryPath : String
            return workDirectoryPath+"/"+@mainSourceDirectoryName

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "mainWorkDirectoryPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def buildDirectoryPath(entry = ISM::Default::Software::MainBuildDirectoryEntry) : String
            return mainWorkDirectoryPath+"/"+"#{@buildDirectory ? @buildDirectoryNames[entry] : ""}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "buildDirectoryPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def builtSoftwareDirectoryPath : String
            return Ism.settings.installByChroot ? "/#{@information.builtSoftwareDirectoryPath}" : "#{Ism.settings.rootPath}#{@information.builtSoftwareDirectoryPath}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "builtSoftwareDirectoryPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def directoryContent(path : String, matchHidden = false) : Array(String)
            path = "#{path}/*"

            fileList = Dir.glob((Ism.settings.installByChroot ? Ism.settings.rootPath+path : path), match: (matchHidden ? File::MatchOptions.glob_default : File::MatchOptions::None))

            return fileList.map { |file| (Ism.settings.installByChroot ? file[(Ism.settings.rootPath.size-1)..-1] : file)}

            rescue exception
            ISM::Core::Error.show(  className: "Software",
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
                                    installedVersion = SemanticVersion.parse(ISM::Core.mainKernelVersion)
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
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "recordSelectedKernel",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "prepareKernelSourcesInstallation",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def setup
        end

        def download
            ISM::Core::Notification.download(@information)

            cleanWorkDirectoryPath

            downloadSources
            downloadSourcesSha512

            if !@additions.empty?
                downloadAdditions
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "download",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def downloadAdditions
            ISM::Core::Notification.downloadAdditions

            downloadAdditionalSources
            downloadAdditionalSourcesSha512

            rescue exception
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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

                            #TO DO
                            # Ism.notifyOfDownloadError(link, error)
                            # Ism.exitProgram
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

                        #TO DO
                        # Ism.notifyOfDownloadError(link, error)
                        # Ism.exitProgram
                    end
                end
            end

            puts

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "downloadFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end
        
        def getFileContent(filePath : String) : String
            begin
                content = File.read(filePath)
            end
            return content

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "getFileContent",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def check
            ISM::Core::Notification.check(@information)

            checkSourcesSha512

            if !@additions.empty?
                checkAdditionsSha512
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "check",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def checkSourcesSha512
            checkFile(  archive:    "#{workDirectoryPathNoChroot}/#{ISM::Default::Software::SourcesArchiveName}",
                        sha512:     getFileContent(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesSha512ArchiveName).strip)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "checkAdditionsSha512",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def checkFile(archive : String, sha512 : String)
            digest = Digest::SHA512.new
            digest.file(archive)
            archiveSha512 = digest.hexfinal

            ISM::Core::Notification.checkIntegrity(ISM::Default::Software::SourcesArchiveBaseName)

            #We check first the archive integrity
            if archiveSha512 != sha512
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "checkFile",
                                        errorTitle: "Integrity verification failed",
                                        error: "The checksum do not match with the downloaded file. The file can be corrupted or compromised.")
            end

            #EXPERIMENTAL
            #ISM::Core::Notification.checkAuthenticity(ISM::Default::Software::SourcesArchiveBaseName)

            #We check now if the authenticity (digital signature)
            #TO DO: Need to decide where to store signatures (for port too)
            # process = ISM::Core.runSystemCommand(   command: "openssl dgst -sha256 -verify PublicFulguranceDevelopement.key -signature #{archive}.sig #{archive}",
            #                                         viaChroot: false,
            #                                         asRoot: false)
            #
            # if !process.success?
            #     ISM::Core::Error.show(  className: "Software",
            #                             functionName: "checkFile",
            #                             errorTitle: "Authenticity verification failed",
            #                             error: "The archive signature does not match with the public key. The file can be corrupted or compromised.")
            # end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "checkFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def extract
            ISM::Core::Notification.extract(@information)

            extractSources

            if !@additions.empty?
                extractAdditions
            end

            #Copy of the current available patches from the port
            if Dir.exists?(@information.mainDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName)
                copyDirectoryNoChroot(@information.mainDirectoryPath+"/"+ISM::Default::Software::PatchesDirectoryName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName)
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "extract",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def extractSources
            extractArchive(workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesArchiveName, workDirectoryPathNoChroot)
            moveFileNoChroot(workDirectoryPathNoChroot+"/"+@information.versionName,workDirectoryPathNoChroot+"/"+ISM::Default::Software::SourcesDirectoryName)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "extractSources",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def extractAdditions
            ISM::Core::Notification.extractAdditions

            @additions.each do |link|
                archiveName = link.lchop(link[0..link.rindex("/")])

                extractArchive("#{workDirectoryPathNoChroot}/#{archiveName}", workDirectoryPathNoChroot)
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "extractAdditions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def extractArchive(archivePath : String, destinationPath = workDirectoryPathNoChroot)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/tar -xf #{archivePath}",
                                                    quiet: true,
                                                    viaChroot: false,
                                                    path: destinationPath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "extractArchive",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end
        
        def patch
            ISM::Core::Notification.patch(@information)

            if Dir.exists?("#{workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName}")
                Dir["#{workDirectoryPathNoChroot+"/"+ISM::Default::Software::PatchesDirectoryName}/*"].each do |patch|
                    applyPatch(patch)
                end
            end

            if Dir.exists?(Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{@information.versionName}")
                Dir[Ism.settings.rootPath+ISM::Default::Path::PatchesDirectory+"/#{@information.versionName}/*"].each do |patch|
                    patchName = patch.lchop(patch[0..patch.rindex("/")])

                    ISM::Core::Notification.localPatch(patchName)

                    applyPatch(patch)
                end
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "patch",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end
        
        def applyPatch(patch : String)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/patch -Np1 -i #{patch}",
                                                    viaChroot: false,
                                                    path: mainWorkDirectoryPathNoChroot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "applyPatch",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def prepare
            ISM::Core::Notification.prepare(@information)

            #Generate all build directories
            @buildDirectoryNames.keys.each do |key|
                if !Dir.exists?(buildDirectoryPathNoChroot(key))
                    makeDirectoryNoChroot(buildDirectoryPathNoChroot(key))
                end
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "prepare",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def copyFileNoChroot(path : String, targetPath : String, asRoot = false)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/cp #{path} #{targetPath}",
                                                    viaChroot: false,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "copyFileNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def copyDirectoryNoChroot(path : String, targetPath : String, asRoot = false)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/cp -R #{path} #{targetPath}",
                                                    viaChroot: false,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "copyDirectoryNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def deleteFileNoChroot(path : String, asRoot = false)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/rm -f #{path}",
                                                    viaChroot: false,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "deleteFileNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def moveFileNoChroot(path : String, newPath : String, asRoot = false)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/mv -f #{path} #{newPath}",
                                                    viaChroot: false,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "moveFileNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def makeDirectoryNoChroot(path : String, asRoot = false)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/mkdir -p #{path}",
                                                    viaChroot: false,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "makeDirectoryNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        #Special function to improve performance (Internal use only)
        def deleteDirectoryNoChroot(path : String, asRoot = false)
            process = ISM::Core.runSystemCommand(   command: "/usr/bin/rm -R -f #{path}",
                                                    viaChroot: false,
                                                    asRoot: asRoot)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "deleteDirectoryNoChroot",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileUpdateContent(path : String, data : String)
            requestedCommands = <<-CMD
            grep -q '#{data}' '#{path}' || echo "#{data}" >> '#{path}'
            CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileUpdateContent",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileReplaceText(path : String, text : String, newText : String)
            requestedCommands = <<-CMD
            sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/g' #{path}
            CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileReplaceText",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileReplaceLineContaining(path : String, text : String, newLine : String)
            requestedCommands = <<-CMD
                                sed -i '/#{text.gsub(/([\.\/])/, %q(\\\1))}/c\#{newText.gsub(/([\.\/])/, %q(\\\1))}' #{path}
                                CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileReplaceLineContaining",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileReplaceTextAtLineNumber(path : String, text : String, newText : String,lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}s/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' #{path}
                                CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileReplaceTextAtLineNumber",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileDeleteLine(path : String, lineNumber : UInt64)
            requestedCommands = <<-CMD
                                sed -i '#{lineNumber.to_s}d' #{path}
                                CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileDeleteLine",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileWriteData(path : String, data : String)
            requestedCommands = <<-CMD
            cat > #{path} <<"EOF"
            #{data}
            EOF
            CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileWriteData",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileAppendData(path : String, data : String)
            requestedCommands = <<-CMD
            echo "#{data}" > "#{path}"
            CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileAppendData",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def fileAppendDataFromFile(path : String, fromPath : String)
            requestedCommands = <<-CMD
            cat "#{fromPath}" >> "#{path}"
            CMD

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "fileAppendDataFromFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def replaceTextAllFilesRecursivelyNamed(path : String, filename : String, text : String, newText : String)
            requestedCommands = <<-CMD
            find -name #{filename} -exec sed -i 's/#{text.gsub(/([\.\/])/, %q(\\\1))}/#{newText.gsub(/([\.\/])/, %q(\\\1))}/' {} \\;
            CMD

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "replaceTextAllFilesRecursivelyNamed",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
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

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "deleteAllFilesRecursivelyFinishing",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
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
                #TO DO
                # Ism.notifyOfMakeLinkUnknowTypeError(target, path, type)
                # Ism.exitProgram
            end

            requestedCommands = "#{command} '#{target}' #{path}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "makeLink",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def generateEmptyFile(path : String)
            requestedCommands = "touch #{path}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "generateEmptyFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def generateEmptyPasswdFile
            requestedCommands = "touch /usr/bin/passwd"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "generateEmptyPasswdFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def copyFile(path : String, targetPath : String)
            requestedCommands = "cp #{path} #{targetPath}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "copyFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def copyDirectory(path : String, targetPath : String)
            requestedCommands = "cp -r #{path} #{targetPath}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "copyDirectory",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def moveFile(path : String, newPath : String)
            requestedCommands = "mv #{path} #{newPath}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "moveFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def makeDirectory(path : String)
            requestedCommands = "mkdir -p #{path}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "makeDirectory",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def deleteDirectory(path : String)
            requestedCommands = "rm -r #{path}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "deleteDirectory",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def deleteFile(path : String)
            requestedCommands = "rm -f #{path}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "deleteFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runChmodCommand(arguments = String.new, path = String.new)
            requestedCommands = "chmod #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runChmodCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runChownCommand(arguments = String.new, path = String.new)
            requestedCommands = "chown #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runChownCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runUserAddCommand(arguments : String)
            requestedCommands = "useradd -R #{Ism.settings.rootPath} #{arguments}"

            process = ISM::Core.runSystemCommand(   command: requestedCommands,
                                                    asRoot: true,
                                                    viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runUserAddCommand",
                                        errorTitle: "User creation failed",
                                        error: "An error occured during the user creation process")
            end
        end

        def runUserDelCommand(arguments : String)
            requestedCommands = "userdel -R #{Ism.settings.rootPath} #{arguments}"

            process = ISM::Core.runSystemCommand(   command: requestedCommands,
                                                    asRoot: true,
                                                    viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runUserDelCommand",
                                        errorTitle: "User deletion failed",
                                        error: "An error occured during the user deletion process")
            end
        end

        def runGroupAddCommand(arguments : String)
            requestedCommands = "groupadd -R #{Ism.settings.rootPath} #{arguments}"

            process = ISM::Core.runSystemCommand(   command: requestedCommands,
                                                    asRoot: true,
                                                    viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGroupAddCommand",
                                        errorTitle: "Group creation failed",
                                        error: "An error occured during the group creation process")
            end
        end

        def runGroupDelCommand(arguments : String)
            requestedCommands = "groupdel -R #{Ism.settings.rootPath} #{arguments}"

            process = ISM::Core.runSystemCommand(   command: requestedCommands,
                                                    asRoot: true,
                                                    viaChroot: false)

            if !process.success? && process.exit_code != 9
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGroupDelCommand",
                                        errorTitle: "Group deletion failed",
                                        error: "An error occured during the group deletion process")
            end
        end

        def runFile(file : String, arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "./#{file} #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runFile",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runTarCommand(arguments = String.new, path = String.new)
            requestedCommands = "tar #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runTarCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runPythonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, version = String.new)
            requestedCommands = "python#{version} #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runPythonCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runPipCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, version = String.new)
            requestedCommands = "pip#{version} #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runPipCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runCrystalCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "CRYSTAL_WORKERS=#{Ism.settings.systemMakeOptions[2..-1]} crystal #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runCrystalCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
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

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runCmakeCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runQmakeCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "qmake #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runQmakeCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runMesonCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "meson #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runMesonCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
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

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runNinjaCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runPwconvCommand(arguments = String.new)
            requestedCommands = "pwconv #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runPwconvCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGrpconvCommand(arguments = String.new)
            requestedCommands = "grpconv #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGrpconvCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runUdevadmCommand(arguments : String)
            requestedCommands = "udevadm #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runUdevadmCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runDbusUuidgenCommand(arguments = String.new)
            requestedCommands = "dbus-uuidgen #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runDbusUuidgenCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runMakeinfoCommand(arguments : String, path = String.new)
            requestedCommands = "makeinfo #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runMakeinfoCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runInstallInfoCommand(arguments : String)
            requestedCommands = "install-info #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runInstallInfoCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runAutoconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoconf #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runAutoconfCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runAutoreconfCommand(arguments = String.new, path = String.new, environment = Hash(String, String).new, environmentFilePath = String.new)
            requestedCommands = "autoreconf #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runAutoreconfCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runLocaledefCommand(arguments : String)
            requestedCommands = "localedef #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runLocaledefCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGunzipCommand(arguments : String, path = String.new)
            requestedCommands = "gunzip #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGunzipCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runMakeCaCommand(arguments : String)
            requestedCommands = "make-ca #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runMakeCaCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runInstallCatalogCommand(arguments : String)
            requestedCommands = "install-catalog #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runInstallCatalogCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runXmlCatalogCommand(arguments : String)
            requestedCommands = "xmlcatalog #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runXmlCatalogCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runLdconfigCommand(arguments = String.new)
            requestedCommands = "ldconfig #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runLdconfigCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGtkQueryImmodules2Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-2.0 #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGtkQueryImmodules2Command",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGtkQueryImmodules3Command(arguments = String.new)
            requestedCommands = "gtk-query-immodules-3.0 #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGtkQueryImmodules3Command",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGlibCompileSchemasCommand(arguments = String.new)
            requestedCommands = "glib-compile-schemas #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGlibCompileSchemasCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGdkPixbufQueryLoadersCommand(arguments = String.new)
            requestedCommands = "gdk-pixbuf-query-loaders #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGdkPixbufQueryLoadersCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runUpdateMimeDatabaseCommand(arguments = String.new)
            requestedCommands = "update-mime-database #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runUpdateMimeDatabaseCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runCargoCommand(arguments : String, path = String.new, environment = Hash(String, String).new)
            requestedCommands = "cargo #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runCargoCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runXargoCommand(arguments : String, path = String.new)
            requestedCommands = "xargo #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runXargoCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGccCommand(arguments = String.new, path = String.new)
            requestedCommands = "gcc #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGccCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runRcUpdateCommand(arguments = String.new)
            requestedCommands = "rc-update #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runRcUpdateCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runAlsactlCommand(arguments = String.new)
            requestedCommands = "alsactl #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runAlsactlCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runGtkUpdateIconCacheCommand(arguments = String.new)
            requestedCommands = "gtk-update-icon-cache #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runGtkUpdateIconCacheCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runUpdateDesktopDatabaseCommand(arguments = String.new)
            requestedCommands = "update-desktop-database #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runUpdateDesktopDatabaseCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runZicCommand(arguments : String, path = String.new)
            requestedCommands = "zic #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runZicCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def prepareOpenrcServiceInstallation(path : String, name : String)
            servicesPath = "/etc/init.d/"

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")
            moveFile(path,"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}#{name}")
            runChmodCommand("+x #{name}","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}#{servicesPath}")

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "prepareOpenrcServiceInstallation",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def configure
            ISM::Core::Notification.configure(@information)
        end

        def configureSource(arguments = String.new, path = String.new, configureDirectory = String.new, environment = Hash(String, String).new, environmentFilePath = String.new, relatedToMainBuild = true)
            configureCommand = "#{@buildDirectory && relatedToMainBuild ? ".." : "."}/#{configureDirectory}/configure"

            requestedCommands = "#{configureCommand} #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "configureSource",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end
        
        def build
            ISM::Core::Notification.build(@information)
        end

        def makePerlSource(path = String.new)
            requestedCommands = "perl Makefile.PL"

            process = ISM::Core.runSystemCommand(requestedCommands, path)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "makePerlSource",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runCpanCommand(arguments = String.new)
            requestedCommands = "cpan #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runCpanCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runDircolorsCommand(arguments = String.new)
            requestedCommands = "dircolors #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands, asRoot: true)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runDircolorsCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runDepmodCommand(arguments = String.new)
            requestedCommands = "depmod #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runDepmodCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def runSshKeygenCommand(arguments = String.new)
            requestedCommands = "ssh-keygen #{arguments}"

            process = ISM::Core.runSystemCommand(requestedCommands)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "runSshKeygenCommand",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
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

            process = ISM::Core.runSystemCommand(requestedCommands, path, environment, environmentFilePath)

            if !process.success?
                ISM::Core::Error.show(  className: "Software",
                                        functionName: "makeSource",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function")
            end
        end

        def prepareInstallation
            ISM::Core::Notification.prepareInstallation(@information)
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

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "recordInstallationInformation",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve performance (Internal use only)
        def stripFileListNoChroot(fileList : Array(String))
            path = "#{Ism.settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::StrippingList}"

            if File.exists?(path)
                deleteFileNoChroot(path: path, asRoot: true)
            end

            data = fileList.join("\n")
            requestedCommands = "/usr/bin/xargs --arg-file=\'#{path}\' /usr/bin/strip --strip-unneeded || true"

            File.write(path, data)

            ISM::Core.runSystemCommand( command: requestedCommands,
                                        quiet: true,
                                        asRoot: systemHandleUserAccess)

            #TO DO
            #No exit process because if the file can't be strip, we can just keep going
            rescue
        end

        #Special function for the installation process without chroot (Internal use only)
        def installFile(target : String, path : String, user : String, group : String, mode : String) : String

            #TEMPORARY DISABLED UNTIL SECURITYMAP ARE SET PROPERLY
            # changeFileModeNoChroot(path, mode, asRoot: true)
            # changeFileOwnerNoChroot(path, user, group, asRoot: true)
            return <<-REQUEST
            #{systemHandleUserAccess ? "/usr/bin/sudo /usr/bin/mv" : "/usr/bin/mv"} -f #{target} #{path}
            REQUEST

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "installFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function for the installation process without chroot (Internal use only)
        def installDirectory(path : String, user : String, group : String, mode : String) : String

            #TEMPORARY DISABLED UNTIL SECURITYMAP ARE SET PROPERLY
            # changeFileModeNoChroot(path, mode, asRoot: true)
            # changeFileOwnerNoChroot(path, user, group, asRoot: true)
            return <<-REQUEST
            #{systemHandleUserAccess ? "/usr/bin/sudo /usr/bin/mkdir -p" : "/usr/bin/mkdir -p"} #{path}
            REQUEST

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "installDirectory",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function for the installation process without chroot (Internal use only)
        def installSymlink(target : String, path : String) : String
            return <<-REQUEST
            #{systemHandleUserAccess ? "/usr/bin/sudo /usr/bin/mv" : "/usr/bin/mv"} -f #{target} #{path}
            REQUEST

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "installSymlink",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function for the installation process (Internal use only)
        def updateSystemCache
            if commandIsAvailable("ldconfig") && systemHandleUserAccess
                runLdconfigCommand
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "updateSystemCache",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function for the uninstallation process without chroot (Internal use only)
        def uninstallFile(path : String)
            deleteFileNoChroot(path, asRoot: true)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "uninstallFile",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function for the uninstallation process without chroot (Internal use only)
        def uninstallDirectory(path : String)
            deleteDirectoryNoChroot(path, asRoot: true)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "uninstallDirectory",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Special function to improve installation process performance (Internal use only)
        def performInstallationRequest(requests : Array(String))
            path = "#{Ism.settings.rootPath}#{ISM::Default::Path::TemporaryDirectory}#{ISM::Default::Filename::InstallationList}"

            if File.exists?(path)
                deleteFileNoChroot(path: path, asRoot: true)
            end

            data = requests.join("\n")
            File.write(path, data)

            ISM::Core.runSystemCommand( command: "/usr/bin/chmod +x #{path}",
                                        quiet: true,
                                        viaChroot: false,
                                        asRoot: systemHandleUserAccess)

            ISM::Core.runSystemCommand( command: path,
                                        quiet: true,
                                        viaChroot: false,
                                        asRoot: systemHandleUserAccess)
        end

        #Manage stripping, recording installed files and favourites, libtool archive removal, and mount/remount critical point with read-only/read-write access
        def install(preserveLibtoolArchives = false, stripFiles = true)
            ISM::Core::Notification.install(@information)

            if systemHandleUserAccess
                ISM::Core::Notification.unlockingSystemAccess
                ISM::Core::Security.unlockSystemAccess

                #Special case when we are switching to the installation by chroot during cross toolchain construction
                if !Ism.settings.installByChroot && !Ism.systemInformation.crossToolchainFullyBuilt
                    prepareRootPermissions
                end

            end

            fileList = Dir.glob(["#{builtSoftwareDirectoryPathNoChroot}/**/*"], match: :dot_files)
            installedFiles = Array(String).new

            ISM::Core::Notification.applyingSecurityMap

            requests = Array(String).new

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
                            requests.push(installDirectory( path:   finalDestination,
                                                            user:   securityDescriptor.user,
                                                            group:  securityDescriptor.group,
                                                            mode:   securityDescriptor.mode))
                        end
                    else
                        #TO DO: Pre check if files are the same
                        if !File.exists?(finalDestination)
                            if File.symlink?(entry)
                                requests.push(installSymlink(   target: entry,
                                                                path:   finalDestination))
                            else
                                requests.push(installFile(  target: entry,
                                                            path:   finalDestination,
                                                            user:   securityDescriptor.user,
                                                            group:  securityDescriptor.group,
                                                            mode:   securityDescriptor.mode))
                            end
                        end
                    end

                end
            end

            performInstallationRequest(requests: requests)

            #Strip the file if needed
            if stripFiles
                ISM::Core::Notification.strippingFiles

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
                ISM::Core::Notification.lockingSystemAccess
                ISM::Core::Security.lockSystemAccess
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "install",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def deploy
            ISM::Core::Notification.deploy
        end

        def kernelSourcesPath : String
            return ISM::Core.kernelSourcesPath

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelSourcesPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def kernelSourcesArchitecturePath : String
            return "#{kernelSourcesPath}arch/"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelSourcesArchitecturePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def kernelKconfigFilePath : String
            return "#{kernelSourcesPath}Kconfig"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelKconfigFilePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def kernelArchitectureKconfigFilePath : String
            return "#{kernelSourcesArchitecturePath}Kconfig"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelArchitectureKconfigFilePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def kernelConfigFilePath : String
            return "#{kernelSourcesPath}.config"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelConfigFilePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def kernelOptionsDatabasePath : String
            return "#{Ism.settings.rootPath}#{ISM::Default::Path::KernelOptionsDirectory}#{mainKernelName}"

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelOptionsDatabasePath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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

            rescue exception
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "generateKernelOptionsFiles",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def updateKernelOptionsDatabase
            ISM::Core::Notification.updateKernelOptionsDatabase(ISM::Core.selectedKernel)

            makeDirectoryNoChroot(kernelOptionsDatabasePath)

            #TO DO
            begin
                generateKernelOptionsFiles(getFullKernelKconfigFile(kernelKconfigFilePath))
                generateKernelOptionsFiles(getFullKernelKconfigFile(kernelArchitectureKconfigFilePath))
            rescue error
                deleteDirectoryNoChroot(kernelOptionsDatabasePath)

                #TO DO
                # Ism.notifyOfUpdateKernelOptionsDatabaseError(Ism.selectedKernel, error)
                # Ism.exitProgram
            end
        end

        def recordNeededKernelOptions
            ISM::Core::Notification.recordNeededKernelOptions

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "recordNeededKernelOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end
        
        def clean
            ISM::Core::Notification.clean(@information)

            cleanWorkDirectoryPath

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "clean",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def cleanWorkDirectoryPath
            if Dir.exists?(workDirectoryPathNoChroot)
                deleteDirectoryNoChroot(workDirectoryPathNoChroot)
            end

            makeDirectoryNoChroot(workDirectoryPathNoChroot)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "cleanWorkDirectoryPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def showInformations
            puts
            ISM::Core::Notification.informationNotificationTitle(@information.name,@information.version)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "showInformations",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def uninstall
            ISM::Core::Notification.uninstall(@information)

            Ism.uninstallSoftware(@information)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "uninstall",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def option(optionName : String) : Bool
            return @information.option(optionName)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "option",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def dependency(fullName : String) : ISM::SoftwareInformation
            @information.dependencies(unsorted: true).each do |entry|
                if entry.fullName == fullName
                    return entry.information
                end
            end

            return ISM::SoftwareInformation.new

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "dependency",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def isGreatestVersion : Bool
            return Ism.getSoftwareInformation(@information.fullName).version <= @information.version

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "isGreatestVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def majorVersion : Int32
            return SemanticVersion.parse(@information.version).major

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "majorVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def minorVersion : Int32
            return SemanticVersion.parse(@information.version).minor

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "minorVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def patchVersion : Int32
            return SemanticVersion.parse(@information.version).patch

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "patchVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Internal use only
        def dependencyVersion(fullName : String) : SemanticVersion
            return SemanticVersion.parse(dependency(fullName).version)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "dependencyVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Internal use only
        def dependencyMajorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).major

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "dependencyMajorVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Internal use only
        def dependencyMinorVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).minor

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "dependencyMinorVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #Internal use only
        def dependencyPatchVersion(fullName : String) : Int32
            return SemanticVersion.parse(dependency(fullName).version).patch

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "dependencyPatchVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def softwareVersion(fullName : String) : SemanticVersion
            if @information.dependencies(unsorted: true).any? { |entry| entry.fullName == fullName}
                return dependencyVersion(fullName)
            else
                return SemanticVersion.parse(Ism.getSoftwareInformation(fullName).version)
            end

            rescue exception
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
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
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "softwarePatchVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def softwareIsInstalled(softwareName : String) : Bool
            return Ism.softwareAnyVersionInstalled(softwareName)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "softwareIsInstalled",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def architecture(architecture : String) : Bool
            return Ism.settings.systemArchitecture == architecture

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "architecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def kernelSelected : Bool
            return selectedKernel.isValid

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "kernelSelected",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def isCurrentKernel : Bool
            return selectedKernel.versionName == @information.versionName

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "isCurrentKernel",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def showInfo(message : String)
            Ism.printInformationNotification(message)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "showInfo",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        def showInfoCode(message : String)
            Ism.printInformationCodeNotification(message)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "showInfoCode",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

        #NEED FIX (Core?)
        def commandIsAvailable(command : String) : Bool
            process = ISM::Core.runSystemCommand("type #{command} > /dev/null 2>&1")

            return (process.exit_code == 0)

            rescue exception
            ISM::Core::Error.show(  className: "Software",
                                    functionName: "commandIsAvailable",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
        end

    end

end
