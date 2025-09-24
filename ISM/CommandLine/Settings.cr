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

                #Host related parameters
                SystemTargetArchitecture = "x86_64"
                SystemTargetVendor = "unknown"
                SystemTargetOs = "linux"
                SystemTargetAbi = "gnu"
                SystemTarget = "#{SystemTargetArchitecture}-#{SystemTargetVendor}-#{SystemTargetOs}-#{SystemTargetAbi}"
                SystemMakeOptions = "-j1"
                SystemBuildOptions = "-march=native -O2 -pipe"
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

                #Chroot related parameters
                ChrootTargetArchitecture = "#{SystemTargetArchitecture}"
                ChrootTargetVendor = "#{SystemTargetVendor}"
                ChrootTargetOs = "#{SystemTargetOs}"
                ChrootTargetAbi = "#{SystemTargetAbi}"
                ChrootTarget = "#{SystemTarget}"
                ChrootMakeOptions = "#{SystemMakeOptions}"
                ChrootBuildOptions = "#{SystemBuildOptions}"
                ChrootName = "#{SystemName}"
                ChrootFullName = "#{SystemFullName}"
                ChrootId = "#{SystemId}"
                ChrootRelease = "#{SystemRelease}"
                ChrootCodeName = "#{SystemCodeName}"
                ChrootDescription = "#{SystemDescription}"
                ChrootVersion = "#{SystemVersion}"
                ChrootVersionId = "#{SystemVersionId}"
                ChrootAnsiColor = "#{SystemAnsiColor}"
                ChrootCpeName = "#{SystemCpeName}"
                ChrootHomeUrl = "#{SystemHomeUrl}"
                ChrootSupportUrl = "#{SystemSupportUrl}"
                ChrootBugReportUrl = "#{SystemBugReportUrl}"
                ChrootPrivacyPolicyUrl = "#{SystemPrivacyPolicyUrl}"
                ChrootBuildId = "#{SystemBuildId}"
                ChrootVariant = "#{SystemVariant}"
                ChrootVariantId = "#{SystemVariantId}"

            end

            include JSON::Serializable

            #Generic parameters
            property    rootPath : String
            property    defaultMirror : String
            property    buildKernelOptionsAsModule : Bool
            property    autoBuildKernel : Bool
            property    autoDeployServices : Bool

            #Host related parameters
            property    systemTargetArchitecture : String
            property    systemTargetVendor : String
            property    systemTargetOs : String
            property    systemTargetAbi : String
            property    systemTarget : String
            property    systemMakeOptions : String
            property    systemBuildOptions : String
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

            #Chroot related parameters
            property    chrootTargetArchitecture : String
            property    chrootTargetVendor : String
            property    chrootTargetOs : String
            property    chrootTargetAbi : String
            property    chrootTarget : String
            property    chrootMakeOptions : String
            property    chrootBuildOptions : String
            property    chrootName : String
            property    chrootFullName : String
            property    chrootId : String
            property    chrootRelease : String
            property    chrootCodeName : String
            property    chrootDescription : String
            property    chrootVersion : String
            property    chrootVersionId : String
            property    chrootAnsiColor : String
            property    chrootCpeName : String
            property    chrootHomeUrl : String
            property    chrootSupportUrl : String
            property    chrootBugReportUrl : String
            property    chrootPrivacyPolicyUrl : String
            property    chrootBuildId : String
            property    chrootVariant : String
            property    chrootVariantId : String

            def initialize( #Generic parameters
                            @rootPath = Default::RootPath,
                            @defaultMirror = Default::DefaultMirror,
                            @buildKernelOptionsAsModule = Default::BuildKernelOptionsAsModule,
                            @autoBuildKernel = Default::AutoBuildKernel,
                            @autoDeployServices = Default::AutoDeployServices,

                            #Host related parameters
                            @systemTargetArchitecture = Default::SystemTargetArchitecture,
                            @systemTargetVendor = Default::SystemTargetVendor,
                            @systemTargetOs = Default::SystemTargetOs,
                            @systemTargetAbi = Default::SystemTargetAbi,
                            @systemTarget = Default::SystemTarget,
                            @systemMakeOptions = Default::SystemMakeOptions,
                            @systemBuildOptions = Default::SystemBuildOptions,
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
                            @systemVariantId = Default::SystemVariantId,

                            #Chroot related parameters
                            @chrootTargetArchitecture = Default::ChrootTargetArchitecture,
                            @chrootTargetVendor = Default::ChrootTargetVendor,
                            @chrootTargetOs = Default::ChrootTargetOs,
                            @chrootTargetAbi = Default::ChrootTargetAbi,
                            @chrootTarget = Default::ChrootTarget,
                            @chrootMakeOptions = Default::ChrootMakeOptions,
                            @chrootBuildOptions = Default::ChrootBuildOptions,
                            @chrootName = Default::ChrootName,
                            @chrootFullName = Default::ChrootFullName,
                            @chrootId = Default::ChrootId,
                            @chrootRelease = Default::ChrootRelease,
                            @chrootCodeName = Default::ChrootCodeName,
                            @chrootDescription = Default::ChrootDescription,
                            @chrootVersion = Default::ChrootVersion,
                            @chrootVersionId = Default::ChrootVersionId,
                            @chrootAnsiColor = Default::ChrootAnsiColor,
                            @chrootCpeName = Default::ChrootCpeName,
                            @chrootHomeUrl = Default::ChrootHomeUrl,
                            @chrootSupportUrl = Default::ChrootSupportUrl,
                            @chrootBugReportUrl = Default::ChrootBugReportUrl,
                            @chrootPrivacyPolicyUrl = Default::ChrootPrivacyPolicyUrl,
                            @chrootBuildId = Default::ChrootBuildId,
                            @chrootVariant = Default::ChrootVariant,
                            @chrootVariantId = Default::ChrootVariantId)
            end

            def self.filePath : String
                return "/"+Default::SettingsFilePath
            end

            def self.generateConfiguration(path = filePath)
                file = File.open(path,"w")
                self.new.to_json(file)
                file.close

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "generateConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def self.loadConfiguration(path = filePath)
                if !File.exists?(path)
                    generateConfiguration(path)
                end

                return from_json(File.read(path))

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "loadConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
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

                                        #Host related parameters
                                        systemTargetArchitecture : String,
                                        systemTargetVendor : String,
                                        systemTargetOs : String,
                                        systemTargetAbi : String,
                                        systemTarget : String,
                                        systemMakeOptions : String,
                                        systemBuildOptions : String,
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
                                        systemVariantId : String,

                                        #Chroot related parameters
                                        chrootTargetArchitecture : String,
                                        chrootTargetVendor : String,
                                        chrootTargetOs : String,
                                        chrootTargetAbi : String,
                                        chrootTarget : String,
                                        chrootMakeOptions : String,
                                        chrootBuildOptions : String,
                                        chrootName : String,
                                        chrootFullName : String,
                                        chrootId : String,
                                        chrootRelease : String,
                                        chrootCodeName : String,
                                        chrootDescription : String,
                                        chrootVersion : String,
                                        chrootVersionId : String,
                                        chrootAnsiColor : String,
                                        chrootCpeName : String,
                                        chrootHomeUrl : String,
                                        chrootSupportUrl : String,
                                        chrootBugReportUrl : String,
                                        chrootPrivacyPolicyUrl : String,
                                        chrootBuildId : String,
                                        chrootVariant : String,
                                        chrootVariantId : String)

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

                            #Host related parameters
                            "systemTargetArchitecture" => systemTargetArchitecture,
                            "systemTargetVendor" => systemTargetVendor,
                            "systemTargetOs" => systemTargetOs,
                            "systemTargetAbi" => systemTargetAbi,
                            "systemTarget" => systemTarget,
                            "systemMakeOptions" => systemMakeOptions,
                            "systemBuildOptions" => systemBuildOptions,
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
                            "systemVariantId" => systemVariantId,

                            #Chroot related parameters
                            "chrootTargetArchitecture" => chrootTargetArchitecture,
                            "chrootTargetVendor" => chrootTargetVendor,
                            "chrootTargetOs" => chrootTargetOs,
                            "chrootTargetAbi" => chrootTargetAbi,
                            "chrootTarget" => chrootTarget,
                            "chrootMakeOptions" => chrootMakeOptions,
                            "chrootBuildOptions" => chrootBuildOptions,
                            "chrootName" => chrootName,
                            "chrootFullName" => chrootFullName,
                            "chrootId" => chrootId,
                            "chrootRelease" => chrootRelease,
                            "chrootCodeName" => chrootCodeName,
                            "chrootDescription" => chrootDescription,
                            "chrootVersion" => chrootVersion,
                            "chrootVersionId" => chrootVersionId,
                            "chrootAnsiColor" => chrootAnsiColor,
                            "chrootCpeName" => chrootCpeName,
                            "chrootHomeUrl" => chrootHomeUrl,
                            "chrootSupportUrl" => chrootSupportUrl,
                            "chrootBugReportUrl" => chrootBugReportUrl,
                            "chrootPrivacyPolicyUrl" => chrootPrivacyPolicyUrl,
                            "chrootBuildId" => chrootBuildId,
                            "chrootVariant" => chrootVariant,
                            "chrootVariantId" => chrootVariantId}


                file = File.open(path,"w")
                settings.to_json(file)
                file.close

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "writeConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def writeChrootConfiguration
                self.class.writeConfiguration(  #File path
                                                @rootPath+Default::SettingsFilePath,
                                                #Generic parameters
                                                Default::RootPath,
                                                @defaultMirror,
                                                @buildKernelOptionsAsModule,
                                                @autoBuildKernel,
                                                @autoDeployServices,

                                                #Host related parameters
                                                @chrootTargetArchitecture,
                                                @chrootTargetVendor,
                                                @chrootTargetOs,
                                                @chrootTargetAbi,
                                                @chrootTarget,
                                                @chrootMakeOptions,
                                                @chrootBuildOptions,
                                                @chrootName,
                                                @chrootFullName,
                                                @chrootId,
                                                @chrootRelease,
                                                @chrootCodeName,
                                                @chrootDescription,
                                                @chrootVersion,
                                                @chrootVersionId,
                                                @chrootAnsiColor,
                                                @chrootCpeName,
                                                @chrootHomeUrl,
                                                @chrootSupportUrl,
                                                @chrootBugReportUrl,
                                                @chrootPrivacyPolicyUrl,
                                                @chrootBuildId,
                                                @chrootVariant,
                                                @chrootVariantId,

                                                #Chroot related parameters
                                                Default::SystemTargetArchitecture,
                                                Default::SystemTargetVendor,
                                                Default::SystemTargetOs,
                                                Default::SystemTargetAbi,
                                                Default::SystemTarget,
                                                Default::SystemMakeOptions,
                                                Default::SystemBuildOptions,
                                                Default::SystemName,
                                                Default::SystemFullName,
                                                Default::SystemId,
                                                Default::SystemRelease,
                                                Default::SystemCodeName,
                                                Default::SystemDescription,
                                                Default::SystemVersion,
                                                Default::SystemVersionId,
                                                Default::SystemAnsiColor,
                                                Default::SystemCpeName,
                                                Default::SystemHomeUrl,
                                                Default::SystemSupportUrl,
                                                Default::SystemBugReportUrl,
                                                Default::SystemPrivacyPolicyUrl,
                                                Default::SystemBuildId,
                                                Default::SystemVariant,
                                                Default::SystemVariantId)

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "writeChrootConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def writeSystemConfiguration
                #We safely check first if a configuration exist already in the chroot, if not the function generate one
                chrootConfiguration = self.class.loadConfiguration(@rootPath+Default::SettingsFilePath)

                self.class.writeConfiguration(  #File path
                                                self.class.filePath,

                                                #Generic parameters
                                                @rootPath,
                                                @defaultMirror,
                                                @buildKernelOptionsAsModule,
                                                @autoBuildKernel,
                                                @autoDeployServices,

                                                #Host related parameters
                                                @systemTargetArchitecture,
                                                @systemTargetVendor,
                                                @systemTargetOs,
                                                @systemTargetAbi,
                                                @systemTarget,
                                                @systemMakeOptions,
                                                @systemBuildOptions,
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
                                                @systemVariantId,

                                                #Chroot related parameters
                                                chrootConfiguration.systemTargetArchitecture,
                                                chrootConfiguration.systemTargetVendor,
                                                chrootConfiguration.systemTargetOs,
                                                chrootConfiguration.systemTargetAbi,
                                                chrootConfiguration.systemTarget,
                                                chrootConfiguration.systemMakeOptions,
                                                chrootConfiguration.systemBuildOptions,
                                                chrootConfiguration.systemName,
                                                chrootConfiguration.systemFullName,
                                                chrootConfiguration.systemId,
                                                chrootConfiguration.systemRelease,
                                                chrootConfiguration.systemCodeName,
                                                chrootConfiguration.systemDescription,
                                                chrootConfiguration.systemVersion,
                                                chrootConfiguration.systemVersionId,
                                                chrootConfiguration.systemAnsiColor,
                                                chrootConfiguration.systemCpeName,
                                                chrootConfiguration.systemHomeUrl,
                                                chrootConfiguration.systemSupportUrl,
                                                chrootConfiguration.systemBugReportUrl,
                                                chrootConfiguration.systemPrivacyPolicyUrl,
                                                chrootConfiguration.systemBuildId,
                                                chrootConfiguration.systemVariant,
                                                chrootConfiguration.systemVariantId)

                if @rootPath != "/"
                    writeChrootConfiguration
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "writeSystemConfiguration",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
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

            #Host/Chroot methods

            def systemTargetArchitecture(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootTargetArchitecture : @systemTargetArchitecture)
                else
                    return @systemTargetArchitecture
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemTargetArchitecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetVendor(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootTargetVendor : @systemTargetVendor)
                else
                    return @systemTargetVendor
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemTargetVendor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetOs(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootTargetOs : @systemTargetOs)
                else
                    return @systemTargetOs
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemTargetOs",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTargetAbi(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootTargetAbi : @systemTargetAbi)
                else
                    return @systemTargetAbi
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemTargetAbi",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemTarget(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootTarget : @systemTarget)
                else
                    return @systemTarget
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemTarget",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemMakeOptions(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootMakeOptions : @systemMakeOptions)
                else
                    return @systemMakeOptions
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemMakeOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemBuildOptions(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootBuildOptions : @systemBuildOptions)
                else
                    return @systemBuildOptions
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemBuildOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemName(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootName : @systemName)
                else
                    return @systemName
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemFullName(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootFullName : @systemFullName)
                else
                    return @systemFullName
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemFullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemId(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootId : @systemId)
                else
                    return @systemId
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemRelease(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootRelease : @systemRelease)
                else
                    return @systemRelease
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemRelease",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemCodeName(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootCodeName : @systemCodeName)
                else
                    return @systemCodeName
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemCodeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemDescription(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootDescription : @systemDescription)
                else
                    return @systemDescription
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemDescription",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVersion(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootVersion : @systemVersion)
                else
                    return @systemVersion
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVersionId(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootVersionId : @systemVersionId)
                else
                    return @systemVersionId
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemVersionId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemAnsiColor(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootAnsiColor : @systemAnsiColor)
                else
                    return @systemAnsiColor
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemAnsiColor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemCpeName(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootCpeName : @systemCpeName)
                else
                    return @systemCpeName
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemCpeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemHomeUrl(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootHomeUrl : @systemHomeUrl)
                else
                    return @systemHomeUrl
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemHomeUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemSupportUrl(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootSupportUrl : @systemSupportUrl)
                else
                    return @systemSupportUrl
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemSupportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemBugReportUrl(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootBugReportUrl : @systemBugReportUrl)
                else
                    return @systemBugReportUrl
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemBugReportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemPrivacyPolicyUrl(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootPrivacyPolicyUrl : @systemPrivacyPolicyUrl)
                else
                    return @systemPrivacyPolicyUrl
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemPrivacyPolicyUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemBuildId(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootBuildId : @systemBuildId)
                else
                    return @systemBuildId
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemBuildId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVariant(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootVariant : @systemVariant)
                else
                    return @systemVariant
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemVariant",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def systemVariantId(relatedToChroot = true) : String
                if relatedToChroot
                    return (@rootPath != "/" ? @chrootVariantId : @systemVariantId)
                else
                    return @systemVariantId
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "systemVariantId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            #Setter methods

            #   Generic
            def setRootPath(@rootPath)
                writeSystemConfiguration

                Ism.loadBaseDirectories

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setRootPath",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setDefaultMirror(@defaultMirror)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setDefaultMirror",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setBuildKernelOptionsAsModule(@buildKernelOptionsAsModule)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setBuildKernelOptionsAsModule",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setAutoBuildKernel(@autoBuildKernel)
                writeSystemConfiguration

                rescue exception
                ISM::Error.show(className: self.class.name,
                                functionName: "setAutoBuildKernel",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

            def setAutoDeployServices(@autoDeployServices)
                writeSystemConfiguration

                rescue exception
                ISM::Error.show(className: self.class.name,
                                functionName: "setAutoDeployServices",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
            end

            #   Host
            def setSystemTargetArchitecture(@systemTargetArchitecture)
                writeSystemConfiguration
                setSystemTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemTargetArchitecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetVendor(@systemTargetVendor)
                writeSystemConfiguration
                setSystemTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemTargetVendor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetOs(@systemTargetOs)
                writeSystemConfiguration
                setSystemTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemTargetOs",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTargetAbi(@systemTargetAbi)
                writeSystemConfiguration
                setSystemTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemTargetAbi",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemTarget
                @systemTarget = "#{@systemTargetArchitecture}-#{@systemTargetVendor}-#{@systemTargetOs}-#{@systemTargetAbi}"
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemTarget",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemMakeOptions(@systemMakeOptions)
                match,invalidValue = Ism.inputMatchWithFilter(@systemMakeOptions,Default::MakeOptionsFilter)

                if match
                    writeSystemConfiguration
                else
                    puts "#{Default::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                    puts "#{Default::ErrorMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                    Ism.exitProgram
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemMakeOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemBuildOptions(@systemBuildOptions)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemBuildOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemName(@systemName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemFullName(@systemFullName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemFullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemId(@systemId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemRelease(@systemRelease)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemRelease",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemCodeName(@systemCodeName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemCodeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemDescription(@systemDescription)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemDescription",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVersion(@systemVersion)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVersionId(@systemVersionId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemVersionId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemAnsiColor(@systemAnsiColor)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemAnsiColor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemCpeName(@systemCpeName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemCpeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemHomeUrl(@systemHomeUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemHomeUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemSupportUrl(@systemSupportUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemSupportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemBugReportUrl(@systemBugReportUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemBugReportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemPrivacyPolicyUrl(@systemPrivacyPolicyUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemPrivacyPolicyUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemBuildId(@systemBuildId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemBuildId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVariant(@systemVariant)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemVariant",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setSystemVariantId(@systemVariantId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setSystemVariantId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            #   Chroot
            def setChrootTargetArchitecture(@chrootTargetArchitecture)
                writeSystemConfiguration
                setChrootTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootTargetArchitecture",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootTargetVendor(@chrootTargetVendor)
                writeSystemConfiguration
                setChrootTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootTargetVendor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootTargetOs(@chrootTargetOs)
                writeSystemConfiguration
                setChrootTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootTargetOs",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootTargetAbi(@chrootTargetAbi)
                writeSystemConfiguration
                setChrootTarget

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootTargetAbi",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootTarget
                @chrootTarget = "#{@chrootTargetArchitecture}-#{@chrootTargetVendor}-#{@chrootTargetOs}-#{@chrootTargetAbi}"
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootTarget",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootMakeOptions(@chrootMakeOptions)
                match,invalidValue = Ism.inputMatchWithFilter(@chrootMakeOptions,Default::MakeOptionsFilter)

                if match
                    writeSystemConfiguration
                else
                    puts "#{Default::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                    puts "#{Default::ErrorChrootMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                    Ism.exitProgram
                end

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootMakeOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootBuildOptions(@chrootBuildOptions)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootBuildOptions",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootName(@chrootName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end


            def setChrootFullName(@chrootFullName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootFullName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootId(@chrootId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootRelease(@chrootRelease)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootRelease",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootCodeName(@chrootCodeName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootCodeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootDescription(@chrootDescription)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootDescription",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootVersion(@chrootVersion)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootVersion",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootVersionId(@chrootVersionId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootVersionId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootAnsiColor(@chrootAnsiColor)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootAnsiColor",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootCpeName(@chrootCpeName)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootCpeName",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootHomeUrl(@chrootHomeUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootHomeUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootSupportUrl(@chrootSupportUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootSupportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootBugReportUrl(@chrootBugReportUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootBugReportUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootPrivacyPolicyUrl(@chrootPrivacyPolicyUrl)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootPrivacyPolicyUrl",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootBuildId(@chrootBuildId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootBuildId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootVariant(@chrootVariant)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootVariant",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

            def setChrootVariantId(@chrootVariantId)
                writeSystemConfiguration

                rescue exception
                    ISM::Error.show(className: self.class.name,
                                    functionName: "setChrootVariantId",
                                    errorTitle: "Execution failure",
                                    error: "Failed to execute the function",
                                    exception: exception)
            end

        end

    end

end
