module ISM

    class CommandLineSettings

        include JSON::Serializable

        #Generic parameters
        property    secureMode : Bool
        property    binaryTaskMode : Bool
        property    installByChroot : Bool
        property    rootPath : String
        property    defaultMirror : String

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
                        @secureMode = ISM::Default::CommandLineSettings::SecureMode,
                        @binaryTaskMode = ISM::Default::CommandLineSettings::BinaryTaskMode,
                        @installByChroot = ISM::Default::CommandLineSettings::InstallByChroot,
                        @rootPath = ISM::Default::CommandLineSettings::RootPath,
                        @defaultMirror = ISM::Default::CommandLineSettings::DefaultMirror,

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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json(file)
            file.close

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def self.writeConfiguration(#File path
                                    path : String,

                                    #Generic parameters
                                    secureMode : Bool,
                                    binaryTaskMode : Bool,
                                    installByChroot : Bool,
                                    rootPath : String,
                                    defaultMirror : String,

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
                        "secureMode" => secureMode,
                        "binaryTaskMode" => binaryTaskMode,
                        "installByChroot" => installByChroot,
                        "rootPath" => rootPath,
                        "defaultMirror" => defaultMirror,

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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def writeChrootConfiguration
            self.class.writeConfiguration(  #File path
                                            @rootPath+ISM::Default::CommandLineSettings::SettingsFilePath,
                                            #Generic parameters
                                            ISM::Default::CommandLineSettings::SecureMode,
                                            ISM::Default::CommandLineSettings::BinaryTaskMode,
                                            ISM::Default::CommandLineSettings::InstallByChroot,
                                            ISM::Default::CommandLineSettings::RootPath,
                                            @defaultMirror,

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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def writeSystemConfiguration
            self.class.writeConfiguration(  #File path
                                            self.class.filePath,

                                            #Generic parameters
                                            @secureMode,
                                            @binaryTaskMode,
                                            @installByChroot,
                                            @rootPath,
                                            @defaultMirror,

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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Generic methods
        def temporaryPath
            return "#{@rootPath}#{ISM::Default::Path::TemporaryDirectory}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def sourcesPath
            return "#{@rootPath}#{ISM::Default::Path::SourcesDirectory}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def toolsPath
            return "#{@rootPath}#{ISM::Default::Path::ToolsDirectory}"

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Host/Chroot methods

        def systemTargetName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTargetName : @systemTargetName)
            else
                return @systemTargetName
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemArchitecture(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootArchitecture : @systemArchitecture)
            else
                return @systemArchitecture
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemTarget(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTarget : @systemTarget)
            else
                return @systemTarget
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemMakeOptions(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootMakeOptions : @systemMakeOptions)
            else
                return @systemMakeOptions
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemBuildOptions(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBuildOptions : @systemBuildOptions)
            else
                return @systemBuildOptions
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootName : @systemName)
            else
                return @systemName
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemFullName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootFullName : @systemFullName)
            else
                return @systemFullName
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootId : @systemId)
            else
                return @systemId
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemRelease(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootRelease : @systemRelease)
            else
                return @systemRelease
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemCodeName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootCodeName : @systemCodeName)
            else
                return @systemCodeName
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemDescription(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootDescription : @systemDescription)
            else
                return @systemDescription
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemVersion(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVersion : @systemVersion)
            else
                return @systemVersion
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemVersionId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVersionId : @systemVersionId)
            else
                return @systemVersionId
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemAnsiColor(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootAnsiColor : @systemAnsiColor)
            else
                return @systemAnsiColor
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemCpeName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootCpeName : @systemCpeName)
            else
                return @systemCpeName
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemHomeUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootHomeUrl : @systemHomeUrl)
            else
                return @systemHomeUrl
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemSupportUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootSupportUrl : @systemSupportUrl)
            else
                return @systemSupportUrl
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemBugReportUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBugReportUrl : @systemBugReportUrl)
            else
                return @systemBugReportUrl
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemPrivacyPolicyUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootPrivacyPolicyUrl : @systemPrivacyPolicyUrl)
            else
                return @systemPrivacyPolicyUrl
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemBuildId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBuildId : @systemBuildId)
            else
                return @systemBuildId
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemVariant(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVariant : @systemVariant)
            else
                return @systemVariant
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def systemVariantId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVariantId : @systemVariantId)
            else
                return @systemVariantId
            end

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #Setter methods

        #   Generic
        def setSecureMode(@secureMode)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setBinaryTaskMode(@binaryTaskMode)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setInstallByChroot(@installByChroot)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setRootPath(@rootPath)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setDefaultMirror(@defaultMirror)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #   Host
        def setSystemTargetName(@systemTargetName)
            writeSystemConfiguration
            setSystemTarget

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemArchitecture(@systemArchitecture)
            writeSystemConfiguration
            setSystemTarget

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemTarget
            @systemTarget = @systemArchitecture + "-" + @systemTargetName + "-" + "linux-gnu"
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemBuildOptions(@systemBuildOptions)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemName(@systemName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemFullName(@systemFullName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemId(@systemId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemRelease(@systemRelease)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemCodeName(@systemCodeName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemDescription(@systemDescription)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemVersion(@systemVersion)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemVersionId(@systemVersionId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemAnsiColor(@systemAnsiColor)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemCpeName(@systemCpeName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemHomeUrl(@systemHomeUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemSupportUrl(@systemSupportUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemBugReportUrl(@systemBugReportUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemPrivacyPolicyUrl(@systemPrivacyPolicyUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemBuildId(@systemBuildId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemVariant(@systemVariant)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setSystemVariantId(@systemVariantId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        #   Chroot
        def setChrootTargetName(@chrootTargetName)
            writeSystemConfiguration
            setChrootTarget

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootArchitecture(@chrootArchitecture)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootTarget
            @chrootTarget = @chrootArchitecture + "-" + @chrootTargetName + "-" + "linux-gnu"
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
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

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootBuildOptions(@chrootBuildOptions)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootName(@chrootName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end


        def setChrootFullName(@chrootFullName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootId(@chrootId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootRelease(@chrootRelease)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootCodeName(@chrootCodeName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootDescription(@chrootDescription)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootVersion(@chrootVersion)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootVersionId(@chrootVersionId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootAnsiColor(@chrootAnsiColor)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootCpeName(@chrootCpeName)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootHomeUrl(@chrootHomeUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootSupportUrl(@chrootSupportUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootBugReportUrl(@chrootBugReportUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootPrivacyPolicyUrl(@chrootPrivacyPolicyUrl)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootBuildId(@chrootBuildId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootVariant(@chrootVariant)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

        def setChrootVariantId(@chrootVariantId)
            writeSystemConfiguration

            rescue error
                Ism.printSystemCallErrorNotification(error)
                Ism.exitProgram
        end

    end

end
