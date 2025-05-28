module ISM

    class CommandLineSettings

        include JSON::Serializable

        #Generic parameters
        property    rootPath : String
        property    defaultMirror : String
        property    buildKernelOptionsAsModule : Bool
        property    autoDeployServices : Bool

        #Host related parameters
        property    systemTargetName : String
        property    systemArchitecture : String
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
        property    chrootTargetName : String
        property    chrootArchitecture : String
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
                        @rootPath = ISM::Default::CommandLineSettings::RootPath,
                        @defaultMirror = ISM::Default::CommandLineSettings::DefaultMirror,
                        @buildKernelOptionsAsModule = ISM::Default::CommandLineSettings::BuildKernelOptionsAsModule,
                        @autoDeployServices = ISM::Default::CommandLineSettings::AutoDeployServices,

                        #Host related parameters
                        @systemTargetName = ISM::Default::CommandLineSettings::SystemTargetName,
                        @systemArchitecture = ISM::Default::CommandLineSettings::SystemArchitecture,
                        @systemTarget = ISM::Default::CommandLineSettings::SystemTarget,
                        @systemMakeOptions = ISM::Default::CommandLineSettings::SystemMakeOptions,
                        @systemBuildOptions = ISM::Default::CommandLineSettings::SystemBuildOptions,
                        @systemName = ISM::Default::CommandLineSettings::SystemName,
                        @systemFullName = ISM::Default::CommandLineSettings::SystemFullName,
                        @systemId = ISM::Default::CommandLineSettings::SystemId,
                        @systemRelease = ISM::Default::CommandLineSettings::SystemRelease,
                        @systemCodeName = ISM::Default::CommandLineSettings::SystemCodeName,
                        @systemDescription = ISM::Default::CommandLineSettings::SystemDescription,
                        @systemVersion = ISM::Default::CommandLineSettings::SystemVersion,
                        @systemVersionId = ISM::Default::CommandLineSettings::SystemVersionId,
                        @systemAnsiColor = ISM::Default::CommandLineSettings::SystemAnsiColor,
                        @systemCpeName = ISM::Default::CommandLineSettings::SystemCpeName,
                        @systemHomeUrl = ISM::Default::CommandLineSettings::SystemHomeUrl,
                        @systemSupportUrl = ISM::Default::CommandLineSettings::SystemSupportUrl,
                        @systemBugReportUrl = ISM::Default::CommandLineSettings::SystemBugReportUrl,
                        @systemPrivacyPolicyUrl = ISM::Default::CommandLineSettings::SystemPrivacyPolicyUrl,
                        @systemBuildId = ISM::Default::CommandLineSettings::SystemBuildId,
                        @systemVariant = ISM::Default::CommandLineSettings::SystemVariant,
                        @systemVariantId = ISM::Default::CommandLineSettings::SystemVariantId,

                        #Chroot related parameters
                        @chrootTargetName = ISM::Default::CommandLineSettings::ChrootTargetName,
                        @chrootArchitecture = ISM::Default::CommandLineSettings::ChrootArchitecture,
                        @chrootTarget = ISM::Default::CommandLineSettings::ChrootTarget,
                        @chrootMakeOptions = ISM::Default::CommandLineSettings::ChrootMakeOptions,
                        @chrootBuildOptions = ISM::Default::CommandLineSettings::ChrootBuildOptions,
                        @chrootName = ISM::Default::CommandLineSettings::ChrootName,
                        @chrootFullName = ISM::Default::CommandLineSettings::ChrootFullName,
                        @chrootId = ISM::Default::CommandLineSettings::ChrootId,
                        @chrootRelease = ISM::Default::CommandLineSettings::ChrootRelease,
                        @chrootCodeName = ISM::Default::CommandLineSettings::ChrootCodeName,
                        @chrootDescription = ISM::Default::CommandLineSettings::ChrootDescription,
                        @chrootVersion = ISM::Default::CommandLineSettings::ChrootVersion,
                        @chrootVersionId = ISM::Default::CommandLineSettings::ChrootVersionId,
                        @chrootAnsiColor = ISM::Default::CommandLineSettings::ChrootAnsiColor,
                        @chrootCpeName = ISM::Default::CommandLineSettings::ChrootCpeName,
                        @chrootHomeUrl = ISM::Default::CommandLineSettings::ChrootHomeUrl,
                        @chrootSupportUrl = ISM::Default::CommandLineSettings::ChrootSupportUrl,
                        @chrootBugReportUrl = ISM::Default::CommandLineSettings::ChrootBugReportUrl,
                        @chrootPrivacyPolicyUrl = ISM::Default::CommandLineSettings::ChrootPrivacyPolicyUrl,
                        @chrootBuildId = ISM::Default::CommandLineSettings::ChrootBuildId,
                        @chrootVariant = ISM::Default::CommandLineSettings::ChrootVariant,
                        @chrootVariantId = ISM::Default::CommandLineSettings::ChrootVariantId)
        end

        def self.filePath : String
            return "/"+ISM::Default::CommandLineSettings::SettingsFilePath
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                                    autoDeployServices : Bool,

                                    #Host related parameters
                                    systemTargetName : String,
                                    systemArchitecture : String,
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
                                    chrootTargetName : String,
                                    chrootArchitecture : String,
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
                        "autoDeployServices" => autoDeployServices,

                        #Host related parameters
                        "systemTargetName" => systemTargetName,
                        "systemArchitecture" => systemArchitecture,
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
                        "chrootTargetName" => chrootTargetName,
                        "chrootArchitecture" => chrootArchitecture,
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
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "writeConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def writeChrootConfiguration
            self.class.writeConfiguration(  #File path
                                            @rootPath+ISM::Default::CommandLineSettings::SettingsFilePath,
                                            #Generic parameters
                                            ISM::Default::CommandLineSettings::RootPath,
                                            @defaultMirror,
                                            @buildKernelOptionsAsModule,
                                            @autoDeployServices,

                                            #Host related parameters
                                            @chrootTargetName,
                                            @chrootArchitecture,
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
                                            ISM::Default::CommandLineSettings::SystemTargetName ,
                                            ISM::Default::CommandLineSettings::SystemArchitecture,
                                            ISM::Default::CommandLineSettings::SystemTarget,
                                            ISM::Default::CommandLineSettings::SystemMakeOptions,
                                            ISM::Default::CommandLineSettings::SystemBuildOptions,
                                            ISM::Default::CommandLineSettings::SystemName,
                                            ISM::Default::CommandLineSettings::SystemFullName,
                                            ISM::Default::CommandLineSettings::SystemId,
                                            ISM::Default::CommandLineSettings::SystemRelease,
                                            ISM::Default::CommandLineSettings::SystemCodeName,
                                            ISM::Default::CommandLineSettings::SystemDescription,
                                            ISM::Default::CommandLineSettings::SystemVersion,
                                            ISM::Default::CommandLineSettings::SystemVersionId,
                                            ISM::Default::CommandLineSettings::SystemAnsiColor,
                                            ISM::Default::CommandLineSettings::SystemCpeName,
                                            ISM::Default::CommandLineSettings::SystemHomeUrl,
                                            ISM::Default::CommandLineSettings::SystemSupportUrl,
                                            ISM::Default::CommandLineSettings::SystemBugReportUrl,
                                            ISM::Default::CommandLineSettings::SystemPrivacyPolicyUrl,
                                            ISM::Default::CommandLineSettings::SystemBuildId,
                                            ISM::Default::CommandLineSettings::SystemVariant,
                                            ISM::Default::CommandLineSettings::SystemVariantId)

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "writeChrootConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def writeSystemConfiguration
            self.class.writeConfiguration(  #File path
                                            self.class.filePath,

                                            #Generic parameters
                                            @rootPath,
                                            @defaultMirror,
                                            @buildKernelOptionsAsModule,
                                            @autoDeployServices,

                                            #Host related parameters
                                            @systemTargetName,
                                            @systemArchitecture,
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
                                            @chrootTargetName,
                                            @chrootArchitecture,
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
                                            @chrootVariantId)

            if @rootPath != "/"
                writeChrootConfiguration
            end

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "writeSystemConfiguration",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Generic methods
        def temporaryPath
            return "#{@rootPath}#{ISM::Default::Path::TemporaryDirectory}"
        end

        def sourcesPath
            return "#{@rootPath}#{ISM::Default::Path::SourcesDirectory}"
        end

        def toolsPath
            return "#{@rootPath}#{ISM::Default::Path::ToolsDirectory}"
        end

        #Host/Chroot methods

        def systemTargetName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTargetName : @systemTargetName)
            else
                return @systemTargetName
            end

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "systemTargetName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def systemArchitecture(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootArchitecture : @systemArchitecture)
            else
                return @systemArchitecture
            end

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "systemArchitecture",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
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
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "systemVariantId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #Setter methods

        #   Generic
        def setRootPath(@rootPath)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setRootPath",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setDefaultMirror(@defaultMirror)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setDefaultMirror",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setBuildKernelOptionsAsModule(@buildKernelOptionsAsModule)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setBuildKernelOptionsAsModule",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setAutoDeployServices(@autoDeployServices)
            writeSystemConfiguration

            rescue exception
            ISM::Error.show(className: "CommandLineSettings",
                            functionName: "setAutoDeployServices",
                            errorTitle: "Execution failure",
                            error: "Failed to execute the function",
                            exception: exception)
        end

        #   Host
        def setSystemTargetName(@systemTargetName)
            writeSystemConfiguration
            setSystemTarget

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemTargetName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemArchitecture(@systemArchitecture)
            writeSystemConfiguration
            setSystemTarget

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemArchitecture",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemTarget
            @systemTarget = @systemArchitecture + "-" + @systemTargetName + "-" + "linux-gnu"
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemTarget",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemMakeOptions(@systemMakeOptions)
            match,invalidValue = Ism.inputMatchWithFilter(@systemMakeOptions,ISM::Default::CommandLineSettings::MakeOptionsFilter)

            if match
                writeSystemConfiguration
            else
                puts "#{ISM::Default::CommandLineSettings::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                puts "#{ISM::Default::CommandLineSettings::ErrorMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                Ism.exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemMakeOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemBuildOptions(@systemBuildOptions)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemBuildOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemName(@systemName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemFullName(@systemFullName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemFullName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemId(@systemId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemRelease(@systemRelease)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemRelease",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemCodeName(@systemCodeName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemCodeName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemDescription(@systemDescription)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemDescription",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemVersion(@systemVersion)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemVersionId(@systemVersionId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemVersionId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemAnsiColor(@systemAnsiColor)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemAnsiColor",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemCpeName(@systemCpeName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemCpeName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemHomeUrl(@systemHomeUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemHomeUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemSupportUrl(@systemSupportUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemSupportUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemBugReportUrl(@systemBugReportUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemBugReportUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemPrivacyPolicyUrl(@systemPrivacyPolicyUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemPrivacyPolicyUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemBuildId(@systemBuildId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemBuildId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemVariant(@systemVariant)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemVariant",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setSystemVariantId(@systemVariantId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setSystemVariantId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        #   Chroot
        def setChrootTargetName(@chrootTargetName)
            writeSystemConfiguration
            setChrootTarget

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootTargetName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootArchitecture(@chrootArchitecture)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootArchitecture",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootTarget
            @chrootTarget = @chrootArchitecture + "-" + @chrootTargetName + "-" + "linux-gnu"
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootTarget",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootMakeOptions(@chrootMakeOptions)
            match,invalidValue = Ism.inputMatchWithFilter(@chrootMakeOptions,ISM::Default::CommandLineSettings::MakeOptionsFilter)

            if match
                writeSystemConfiguration
            else
                puts "#{ISM::Default::CommandLineSettings::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                puts "#{ISM::Default::CommandLineSettings::ErrorChrootMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                Ism.exitProgram
            end

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootMakeOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootBuildOptions(@chrootBuildOptions)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootBuildOptions",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootName(@chrootName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end


        def setChrootFullName(@chrootFullName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootFullName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootId(@chrootId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootRelease(@chrootRelease)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootRelease",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootCodeName(@chrootCodeName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootCodeName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootDescription(@chrootDescription)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootDescription",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootVersion(@chrootVersion)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootVersion",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootVersionId(@chrootVersionId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootVersionId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootAnsiColor(@chrootAnsiColor)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootAnsiColor",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootCpeName(@chrootCpeName)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootCpeName",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootHomeUrl(@chrootHomeUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootHomeUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootSupportUrl(@chrootSupportUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootSupportUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootBugReportUrl(@chrootBugReportUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootBugReportUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootPrivacyPolicyUrl(@chrootPrivacyPolicyUrl)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootPrivacyPolicyUrl",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootBuildId(@chrootBuildId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootBuildId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootVariant(@chrootVariant)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootVariant",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

        def setChrootVariantId(@chrootVariantId)
            writeSystemConfiguration

            rescue exception
                ISM::Error.show(className: "CommandLineSettings",
                                functionName: "setChrootVariantId",
                                errorTitle: "Execution failure",
                                error: "Failed to execute the function",
                                exception: exception)
        end

    end

end
