module ISM

    class CommandLine

        class Settings

            module Default

                #Class related
                MakeOptionsFilter = /-j[0-9]/
                SettingsFilePath = "#{Path::SettingsDirectory}#{Filename::Settings}"
                ErrorInvalidValueText = "Invalid value detected: "
                ErrorMakeOptionsInvalidValueAdviceText = "The input value must be of the form -jX where X is the number of jobs to run simultaneously"
                ErrorChrootMakeOptionsInvalidValueAdviceText = "The input value must be of the form -jX where X is the number of jobs to run simultaneously"

                #Generic parameters
                RootPath = "/"
                DefaultMirror = "Uk"
                BuildKernelOptionsAsModule = true
                AutoBuildKernel = true
                AutoDeployServices = true
                MakeOptions = "-j1"
                BuildOptions = "-march=native -O2 -pipe"

                #Host related parameters
                SystemTargetArchitecture = "x86_64"
                SystemTargetVendor = "unknown"
                SystemTargetOs = "linux"
                SystemTargetAbi = "gnu"
                SystemTarget = "#{SystemTargetArchitecture}-#{SystemTargetVendor}-#{SystemTargetOs}-#{SystemTargetAbi}"
                SystemName = "Unknown"
                SystemFullName ="Unknown Linux System"
                SystemId = "?"
                SystemRelease = "?"
                SystemCodeName = "?"
                SystemDescription = "None"
                SystemVersion = "?"
                SystemVersionId = "?"
                SystemAnsiColor = "?"
                SystemCpeName = "Unknown"
                SystemHomeUrl = "None"
                SystemSupportUrl = "None"
                SystemBugReportUrl = "None"
                SystemPrivacyPolicyUrl = "None"
                SystemBuildId = "?"
                SystemVariant = "None"
                SystemVariantId = "None"

            end

            include JSON::Serializable

            #Generic parameters
            property    rootPath : String
            property    defaultMirror : String
            property    buildKernelOptionsAsModule : Bool
            property    autoBuildKernel : Bool
            property    autoDeployServices : Bool
            property    makeOptions : String
            property    buildOptions : String

            #Host related parameters
            property    systemTargetArchitecture : String
            property    systemTargetVendor : String
            property    systemTargetOs : String
            property    systemTargetAbi : String
            property    systemTarget : String
            property    systemName : String
            property    systemFullName : String
            property    systemId : String
            property    systemRelease : String
            property    systemCodeName : String
            property    systemDescription : String
            property    systemVersion : String
            property    systemVersionId : String
            property    systemAnsiColor : String
            property    systemCpeName : String
            property    systemHomeUrl : String
            property    systemSupportUrl : String
            property    systemBugReportUrl : String
            property    systemPrivacyPolicyUrl : String
            property    systemBuildId : String
            property    systemVariant : String
            property    systemVariantId : String

            def initialize( #Generic parameters
                            @rootPath = Default::RootPath,
                            @defaultMirror = Default::DefaultMirror,
                            @buildKernelOptionsAsModule = Default::BuildKernelOptionsAsModule,
                            @autoBuildKernel = Default::AutoBuildKernel,
                            @autoDeployServices = Default::AutoDeployServices,
                            @makeOptions = Default::MakeOptions,
                            @buildOptions = Default::BuildOptions,

                            #Host related parameters
                            @systemTargetArchitecture = Default::SystemTargetArchitecture,
                            @systemTargetVendor = Default::SystemTargetVendor,
                            @systemTargetOs = Default::SystemTargetOs,
                            @systemTargetAbi = Default::SystemTargetAbi,
                            @systemTarget = Default::SystemTarget,
                            @systemName = Default::SystemName,
                            @systemFullName = Default::SystemFullName,
                            @systemId = Default::SystemId,
                            @systemRelease = Default::SystemRelease,
                            @systemCodeName = Default::SystemCodeName,
                            @systemDescription = Default::SystemDescription,
                            @systemVersion = Default::SystemVersion,
                            @systemVersionId = Default::SystemVersionId,
                            @systemAnsiColor = Default::SystemAnsiColor,
                            @systemCpeName = Default::SystemCpeName,
                            @systemHomeUrl = Default::SystemHomeUrl,
                            @systemSupportUrl = Default::SystemSupportUrl,
                            @systemBugReportUrl = Default::SystemBugReportUrl,
                            @systemPrivacyPolicyUrl = Default::SystemPrivacyPolicyUrl,
                            @systemBuildId = Default::SystemBuildId,
                            @systemVariant = Default::SystemVariant,
                            @systemVariantId = Default::SystemVariantId)
            end

            def self.filePath : String
                return "/"+Default::SettingsFilePath
            end

            def self.generateConfiguration(path = filePath)
                finalPath = path.chomp(path[path.rindex("/")..-1])

                if !Dir.exists?(finalPath)
                    Dir.mkdir_p(finalPath)
                end

                file = File.open(path,"w")
                self.new.to_json(file)
                file.close

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "generateConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to generate configuration file to #{path}",
                                    exception: exception)
            end

            def self.loadConfiguration(path = filePath)
                if !File.exists?(path)
                    generateConfiguration(path)
                end

                return from_json(File.read(path))

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "loadConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to load configuration file from #{path}",
                                    exception: exception)
            end

            def self.writeConfiguration(#File path
                                        path : String,

                                        #Generic parameters
                                        rootPath : String,
                                        defaultMirror : String,
                                        buildKernelOptionsAsModule : Bool,
                                        autoBuildKernel : Bool,
                                        autoDeployServices : Bool,
                                        makeOptions : String,
                                        buildOptions : String,

                                        #Host related parameters
                                        systemTargetArchitecture : String,
                                        systemTargetVendor : String,
                                        systemTargetOs : String,
                                        systemTargetAbi : String,
                                        systemTarget : String,
                                        systemName : String,
                                        systemFullName : String,
                                        systemId : String,
                                        systemRelease : String,
                                        systemCodeName : String,
                                        systemDescription : String,
                                        systemVersion : String,
                                        systemVersionId : String,
                                        systemAnsiColor : String,
                                        systemCpeName : String,
                                        systemHomeUrl : String,
                                        systemSupportUrl : String,
                                        systemBugReportUrl : String,
                                        systemPrivacyPolicyUrl : String,
                                        systemBuildId : String,
                                        systemVariant : String,
                                        systemVariantId : String)

                finalPath = path.chomp(path[path.rindex("/")..-1])

                if !Dir.exists?(finalPath)
                    Dir.mkdir_p(finalPath)
                end

                settings = {#Generic parameters
                            "rootPath" => rootPath,
                            "defaultMirror" => defaultMirror,
                            "buildKernelOptionsAsModule" => buildKernelOptionsAsModule,
                            "autoBuildKernel" => autoBuildKernel,
                            "autoDeployServices" => autoDeployServices,
                            "makeOptions" => makeOptions,
                            "buildOptions" => buildOptions,

                            #Host related parameters
                            "systemTargetArchitecture" => systemTargetArchitecture,
                            "systemTargetVendor" => systemTargetVendor,
                            "systemTargetOs" => systemTargetOs,
                            "systemTargetAbi" => systemTargetAbi,
                            "systemTarget" => systemTarget,
                            "systemName" => systemName,
                            "systemFullName" => systemFullName,
                            "systemId" => systemId,
                            "systemRelease" => systemRelease,
                            "systemCodeName" => systemCodeName,
                            "systemDescription" => systemDescription,
                            "systemVersion" => systemVersion,
                            "systemVersionId" => systemVersionId,
                            "systemAnsiColor" => systemAnsiColor,
                            "systemCpeName" => systemCpeName,
                            "systemHomeUrl" => systemHomeUrl,
                            "systemSupportUrl" => systemSupportUrl,
                            "systemBugReportUrl" => systemBugReportUrl,
                            "systemPrivacyPolicyUrl" => systemPrivacyPolicyUrl,
                            "systemBuildId" => systemBuildId,
                            "systemVariant" => systemVariant,
                            "systemVariantId" => systemVariantId}


                file = File.open(path,"w")
                settings.to_json(file)
                file.close

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "writeConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to write configuration file to #{path}",
                                    exception: exception)
            end

            def writeSystemConfiguration
                self.class.writeConfiguration(  #File path
                                                self.class.filePath,

                                                #Generic parameters
                                                @rootPath,
                                                @defaultMirror,
                                                @buildKernelOptionsAsModule,
                                                @autoBuildKernel,
                                                @autoDeployServices,
                                                @makeOptions,
                                                @buildOptions,

                                                #Host related parameters
                                                @systemTargetArchitecture,
                                                @systemTargetVendor,
                                                @systemTargetOs,
                                                @systemTargetAbi,
                                                @systemTarget,
                                                @systemName,
                                                @systemFullName,
                                                @systemId,
                                                @systemRelease,
                                                @systemCodeName,
                                                @systemDescription,
                                                @systemVersion,
                                                @systemVersionId,
                                                @systemAnsiColor,
                                                @systemCpeName,
                                                @systemHomeUrl,
                                                @systemSupportUrl,
                                                @systemBugReportUrl,
                                                @systemPrivacyPolicyUrl,
                                                @systemBuildId,
                                                @systemVariant,
                                                @systemVariantId)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "writeSystemConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to write system configuration file to #{self.class.filePath}",
                                    exception: exception)
            end

            def writeChrootConfiguration(   defaultMirror = chrootConfiguration.defaultMirror,
                                            buildKernelOptionsAsModule = chrootConfiguration.buildKernelOptionsAsModule,
                                            autoBuildKernel = chrootConfiguration.autoBuildKernel,
                                            autoDeployServices = chrootConfiguration.autoDeployServices,
                                            makeOptions = chrootConfiguration.makeOptions,
                                            buildOptions = chrootConfiguration.buildOptions,
                                            systemTargetArchitecture = chrootConfiguration.systemTargetArchitecture,
                                            systemTargetVendor = chrootConfiguration.systemTargetVendor,
                                            systemTargetOs = chrootConfiguration.systemTargetOs,
                                            systemTargetAbi = chrootConfiguration.systemTargetAbi,
                                            systemTarget = chrootConfiguration.systemTarget,
                                            systemName = chrootConfiguration.systemName,
                                            systemFullName = chrootConfiguration.systemFullName,
                                            systemId = chrootConfiguration.systemId,
                                            systemRelease = chrootConfiguration.systemRelease,
                                            systemCodeName = chrootConfiguration.systemCodeName,
                                            systemDescription = chrootConfiguration.systemDescription,
                                            systemVersion = chrootConfiguration.systemVersion,
                                            systemVersionId = chrootConfiguration.systemVersionId,
                                            systemAnsiColor = chrootConfiguration.systemAnsiColor,
                                            systemCpeName = chrootConfiguration.systemCpeName,
                                            systemHomeUrl = chrootConfiguration.systemHomeUrl,
                                            systemSupportUrl = chrootConfiguration.systemSupportUrl,
                                            systemBugReportUrl = chrootConfiguration.systemBugReportUrl,
                                            systemPrivacyPolicyUrl = chrootConfiguration.systemPrivacyPolicyUrl,
                                            systemBuildId = chrootConfiguration.systemBuildId,
                                            systemVariant = chrootConfiguration.systemVariant,
                                            systemVariantId = chrootConfiguration.systemVariantId)
                self.class.writeConfiguration(  #File path
                                                @rootPath+Default::SettingsFilePath,
                                                #Generic parameters
                                                Default::RootPath,
                                                defaultMirror,
                                                buildKernelOptionsAsModule,
                                                autoBuildKernel,
                                                autoDeployServices,
                                                makeOptions,
                                                buildOptions,
                                                systemTargetArchitecture,
                                                systemTargetVendor,
                                                systemTargetOs,
                                                systemTargetAbi,
                                                systemTarget,
                                                systemName,
                                                systemFullName,
                                                systemId,
                                                systemRelease,
                                                systemCodeName,
                                                systemDescription,
                                                systemVersion,
                                                systemVersionId,
                                                systemAnsiColor,
                                                systemCpeName,
                                                systemHomeUrl,
                                                systemSupportUrl,
                                                systemBugReportUrl,
                                                systemPrivacyPolicyUrl,
                                                systemBuildId,
                                                systemVariant,
                                                systemVariantId)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "writeChrootConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to write chroot configuration file to #{@rootPath+Default::SettingsFilePath}",
                                    exception: exception)
            end

            #Generic methods
            def temporaryPath
                return "#{@rootPath}#{Path::TemporaryDirectory}"
            end

            def sourcesPath
                return "#{@rootPath}#{Path::SourcesDirectory}"
            end

            def toolsPath
                return "#{@rootPath}#{Path::ToolsDirectory}"
            end

            def chrootConfiguration
                path = @rootPath+Default::SettingsFilePath

                return self.class.loadConfiguration(path)
            end

            #Host/Chroot methods (Used by software installer API)

            def systemMakeOptions(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.makeOptions
                else
                    return @makeOptions
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "makeOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemBuildOptions(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.buildOptions
                else
                    return @buildOptions
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "buildOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetArchitecture(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemTargetArchitecture
                else
                    return @systemTargetArchitecture
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemTargetArchitecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetVendor(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemTargetVendor
                else
                    return @systemTargetVendor
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemTargetVendor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetOs(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemTargetOs
                else
                    return @systemTargetOs
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemTargetOs",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetAbi(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemTargetAbi
                else
                    return @systemTargetAbi
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemTargetAbi",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTarget(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemTarget
                else
                    return @systemTarget
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemTarget",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemName(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemName
                else
                    return @systemName
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemFullName(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemFullName
                else
                    return @systemFullName
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemFullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemId(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemId
                else
                    return @systemId
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemRelease(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemRelease
                else
                    return @systemRelease
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemRelease",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemCodeName(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemCodeName
                else
                    return @systemCodeName
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemCodeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemDescription(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemDescription
                else
                    return @systemDescription
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemDescription",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVersion(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemVersion
                else
                    return @systemVersion
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVersionId(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemVersionId
                else
                    return @systemVersionId
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemVersionId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemAnsiColor(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemAnsiColor
                else
                    return @systemAnsiColor
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemAnsiColor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemCpeName(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemCpeName
                else
                    return @systemCpeName
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemCpeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemHomeUrl(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemHomeUrl
                else
                    return @systemHomeUrl
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemHomeUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemSupportUrl(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemSupportUrl
                else
                    return @systemSupportUrl
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemSupportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemBugReportUrl(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemBugReportUrl
                else
                    return @systemBugReportUrl
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemBugReportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemPrivacyPolicyUrl(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemPrivacyPolicyUrl
                else
                    return @systemPrivacyPolicyUrl
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemPrivacyPolicyUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemBuildId(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemBuildId
                else
                    return @systemBuildId
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemBuildId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVariant(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemVariant
                else
                    return @systemVariant
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemVariant",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVariantId(relatedToChroot = true) : String
                if relatedToChroot && @rootPath != "/"
                    return chrootConfiguration.systemVariantId
                else
                    return @systemVariantId
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "systemVariantId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            #Chroot getter methods

            def chrootDefaultMirror : String
                return chrootConfiguration.defaultMirror
            end

            def chrootBuildKernelOptionsAsModule : String
                return chrootConfiguration.buildKernelOptionsAsModule
            end

            def chrootAutoBuildKernel : String
                return chrootConfiguration.autoBuildKernel
            end

            def chrootAutoDeployServices : String
                return chrootConfiguration.autoDeployServices
            end

            def chrootMakeOptions : String
                return chrootConfiguration.makeOptions
            end

            def chrootBuildOptions : String
                return chrootConfiguration.buildOptions
            end

            def chrootSystemTargetArchitecture : String
                return chrootConfiguration.systemTargetArchitecture
            end

            def chrootSystemTargetVendor : String
                return chrootConfiguration.systemTargetVendor
            end

            def chrootSystemTargetOs : String
                return chrootConfiguration.systemTargetOs
            end

            def chrootSystemTargetAbi : String
                return chrootConfiguration.systemTargetAbi
            end

            def chrootSystemTarget : String
                return chrootConfiguration.systemTarget
            end

            def chrootSystemName : String
                return chrootConfiguration.systemName
            end

            def chrootSystemFullName : String
                return chrootConfiguration.systemFullName
            end

            def chrootSystemId : String
                return chrootConfiguration.systemId
            end

            def chrootSystemRelease : String
                return chrootConfiguration.systemRelease
            end

            def chrootSystemCodeName : String
                return chrootConfiguration.systemCodeName
            end

            def chrootSystemDescription : String
                return chrootConfiguration.systemDescription
            end

            def chrootSystemVersion : String
                return chrootConfiguration.systemVersion
            end

            def chrootSystemVersionId : String
                return chrootConfiguration.systemVersionId
            end

            def chrootSystemAnsiColor : String
                return chrootConfiguration.systemAnsiColor
            end

            def chrootSystemCpeName : String
                return chrootConfiguration.systemCpeName
            end

            def chrootSystemHomeUrl : String
                return chrootConfiguration.systemHomeUrl
            end

            def chrootSystemSupportUrl : String
                return chrootConfiguration.systemSupportUrl
            end

            def chrootSystemBugReportUrl : String
                return chrootConfiguration.systemBugReportUrl
            end

            def chrootSystemPrivacyPolicyUrl : String
                return systemPrivacyPolicyUrl = chrootConfiguration.systemPrivacyPolicyUrl
            end

            def chrootSystemBuildId : String
                return chrootConfiguration.systemBuildId
            end

            def chrootSystemVariant : String
                return chrootConfiguration.systemVariant
            end

            def chrootSystemVariantId : String
                return chrootConfiguration.systemVariantId
            end

            #Setter methods

            #   Generic
            def setRootPath(@rootPath)
                writeSystemConfiguration

                Ism.loadBaseDirectories

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setRootPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            #   Host
            def setDefaultMirror(@defaultMirror)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setDefaultMirror",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setBuildKernelOptionsAsModule(@buildKernelOptionsAsModule)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setBuildKernelOptionsAsModule",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setAutoBuildKernel(@autoBuildKernel)
                writeSystemConfiguration

                rescue exception
                ISM::Error.show(className: "Settings",
                                functionName: "setAutoBuildKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

            def setAutoDeployServices(@autoDeployServices)
                writeSystemConfiguration

                rescue exception
                ISM::Error.show(className: "Settings",
                                functionName: "setAutoDeployServices",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

            def setMakeOptions(value : String)
                if Default::MakeOptionsFilter.matches?(value)
                    @makeOptions = value
                    writeSystemConfiguration
                else
                    puts "#{Default::ErrorInvalidValueText.colorize(:red)}#{value.colorize(:red)}"
                    puts "#{Default::ErrorMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                    Ism.exitProgram
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setMakeOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setBuildOptions(@buildOptions)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setBuildOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetArchitecture(@systemTargetArchitecture)
                setSystemTarget
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemTargetArchitecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetVendor(@systemTargetVendor)
                setSystemTarget
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemTargetVendor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetOs(@systemTargetOs)
                setSystemTarget
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemTargetOs",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetAbi(@systemTargetAbi)
                setSystemTarget
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemTargetAbi",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTarget
                @systemTarget = "#{@systemTargetArchitecture}-#{@systemTargetVendor}-#{@systemTargetOs}-#{@systemTargetAbi}"

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemTarget",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemName(@systemName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemFullName(@systemFullName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemFullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemId(@systemId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemRelease(@systemRelease)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemRelease",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemCodeName(@systemCodeName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemCodeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemDescription(@systemDescription)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemDescription",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVersion(@systemVersion)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVersionId(@systemVersionId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemVersionId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemAnsiColor(@systemAnsiColor)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemAnsiColor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemCpeName(@systemCpeName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemCpeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemHomeUrl(@systemHomeUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemHomeUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemSupportUrl(@systemSupportUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemSupportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemBugReportUrl(@systemBugReportUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemBugReportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemPrivacyPolicyUrl(@systemPrivacyPolicyUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemPrivacyPolicyUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemBuildId(@systemBuildId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemBuildId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVariant(@systemVariant)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemVariant",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVariantId(@systemVariantId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setSystemVariantId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            #   Chroot
            def setChrootDefaultMirror(value : String)
                writeChrootConfiguration(defaultMirror: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootDefaultMirror",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootBuildKernelOptionsAsModule(value : Bool)
                writeChrootConfiguration(buildKernelOptionsAsModule: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootBuildKernelOptionsAsModule",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootAutoBuildKernel(value : Bool)
                writeChrootConfiguration(autoBuildKernel: value)

                rescue exception
                ISM::Error.show(className: "Settings",
                                functionName: "setChrootAutoBuildKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

            def setChrootAutoDeployServices(value : Bool)
                writeChrootConfiguration(autoDeployServices: value)

                rescue exception
                ISM::Error.show(className: "Settings",
                                functionName: "setChrootAutoDeployServices",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

            def setChrootMakeOptions(value : String)
                if Default::MakeOptionsFilter.matches?(value)
                    writeChrootConfiguration(makeOptions: value)
                else
                    puts "#{Default::ErrorInvalidValueText.colorize(:red)}#{value.colorize(:red)}"
                    puts "#{Default::ErrorChrootMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                    Ism.exitProgram
                end

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootMakeOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootBuildOptions(value : String)
                writeChrootConfiguration(buildOptions: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootBuildOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemTargetArchitecture(value : String)
                setChrootSystemTarget(architecture: value)
                writeChrootConfiguration(systemTargetArchitecture: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemTargetArchitecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemTargetVendor(value : String)
                setChrootSystemTarget(vendor: value)
                writeChrootConfiguration(systemTargetVendor: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemTargetVendor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemTargetOs(value : String)
                setChrootSystemTarget(os: value)
                writeChrootConfiguration(systemTargetOs: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemTargetOs",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemTargetAbi(value : String)
                setChrootSystemTarget(abi: value)
                writeChrootConfiguration(systemTargetAbi: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemTargetAbi",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemTarget(architecture = chrootConfiguration.systemTargetArchitecture,
                                vendor = chrootConfiguration.systemTargetVendor,
                                os = chrootConfiguration.systemTargetOs,
                                abi = chrootConfiguration.systemTargetAbi)

                writeChrootConfiguration(systemTarget: "#{architecture}-#{vendor}-#{os}-#{abi}")

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemTarget",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemName(value : String)
                writeChrootConfiguration(systemName: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end


            def setChrootSystemFullName(value : String)
                writeChrootConfiguration(systemFullName: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemFullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemId(value : String)
                writeChrootConfiguration(systemId: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemRelease(value : String)
                writeChrootConfiguration(systemRelease: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemRelease",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemCodeName(value : String)
                writeChrootConfiguration(systemCodeName: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemCodeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemDescription(value : String)
                writeChrootConfiguration(systemDescription: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemDescription",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemVersion(value : String)
                writeChrootConfiguration(systemVersion: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemVersionId(value : String)
                writeChrootConfiguration(systemVersionId: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemVersionId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemAnsiColor(value : String)
                writeChrootConfiguration(systemAnsiColor: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemAnsiColor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemCpeName(value : String)
                writeChrootConfiguration(systemCpeName: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemCpeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemHomeUrl(value : String)
                writeChrootConfiguration(systemHomeUrl: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemHomeUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemSupportUrl(value : String)
                writeChrootConfiguration(systemSupportUrl: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemSupportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemBugReportUrl(value : String)
                writeChrootConfiguration(systemBugReportUrl: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemBugReportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemPrivacyPolicyUrl(value : String)
                writeChrootConfiguration(systemPrivacyPolicyUrl: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemPrivacyPolicyUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemBuildId(value : String)
                writeChrootConfiguration(systemBuildId: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemBuildId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemVariant(value : String)
                writeChrootConfiguration(systemVariant: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemVariant",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSystemVariantId(value : String)
                writeChrootConfiguration(systemVariantId: value)

                rescue exception
                    ISM::Error.show(className: "Settings",
                                    functionName: "setChrootSystemVariantId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

        end

    end

end
