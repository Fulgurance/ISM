module ISM

    class CommandLineSettings

        record Settings,
            #Generic parameters
            secureMode : Bool,
            installByChroot : Bool,
            rootPath : String,
            defaultMirror : String,

            #Host related parameters
            targetName : String,
            architecture : String,
            target : String,
            makeOptions : String,
            buildOptions : String,
            name : String,
            fullName : String,
            id : String,
            release : String,
            codeName : String,
            description : String,
            version : String,
            ansiColor : String,
            cpeName : String,
            homeUrl : String,
            supportUrl : String,
            bugReportUrl : String,
            privacyPolicyUrl : String,
            buildId : String,
            variant : String,
            variantId : String,

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
            chrootAnsiColor : String,
            chrootCpeName : String,
            chrootHomeUrl : String,
            chrootSupportUrl : String,
            chrootBugReportUrl : String,
            chrootPrivacyPolicyUrl : String,
            chrootBuildId : String,
            chrootVariant : String,
            chrootVariantId : String do

            include JSON::Serializable
        end

        #Generic parameters
        property    secureMode : Bool
        property    installByChroot : Bool
        property    rootPath : String
        property    defaultMirror : String

        #Host related parameters
        property    targetName : String
        property    architecture : String
        property    target : String
        property    makeOptions : String
        property    buildOptions : String
        property    name : String
        property    fullName : String
        property    id : String
        property    release : String
        property    codeName : String
        property    description : String
        property    version : String
        property    ansiColor : String
        property    cpeName : String
        property    homeUrl : String
        property    supportUrl : String
        property    bugReportUrl : String
        property    privacyPolicyUrl : String
        property    buildId : String
        property    variant : String
        property    variantId : String

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
                        @installByChroot = ISM::Default::CommandLineSettings::InstallByChroot,
                        @rootPath = ISM::Default::CommandLineSettings::RootPath,
                        @defaultMirror = ISM::Default::CommandLineSettings::DefaultMirror,

                        #Host related parameters
                        @targetName = ISM::Default::CommandLineSettings::TargetName ,
                        @architecture = ISM::Default::CommandLineSettings::Architecture,
                        @target = ISM::Default::CommandLineSettings::Target,
                        @makeOptions = ISM::Default::CommandLineSettings::MakeOptions,
                        @buildOptions = ISM::Default::CommandLineSettings::BuildOptions,
                        @name = ISM::Default::CommandLineSettings::Name,
                        @fullName = ISM::Default::CommandLineSettings::FullName,
                        @id = ISM::Default::CommandLineSettings::Id,
                        @release = ISM::Default::CommandLineSettings::Release,
                        @codeName = ISM::Default::CommandLineSettings::CodeName,
                        @description = ISM::Default::CommandLineSettings::Description,
                        @version = ISM::Default::CommandLineSettings::Version,
                        @ansiColor = ISM::Default::CommandLineSettings::AnsiColor,
                        @cpeName = ISM::Default::CommandLineSettings::CpeName,
                        @homeUrl = ISM::Default::CommandLineSettings::HomeUrl,
                        @supportUrl = ISM::Default::CommandLineSettings::SupportUrl,
                        @bugReportUrl = ISM::Default::CommandLineSettings::BugReportUrl,
                        @privacyPolicyUrl = ISM::Default::CommandLineSettings::PrivacyPolicyUrl,
                        @buildId = ISM::Default::CommandLineSettings::BuildId,
                        @variant = ISM::Default::CommandLineSettings::Variant,
                        @variantId = ISM::Default::CommandLineSettings::VariantId,

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

        def loadSettingsFile
            if !File.exists?("/"+ISM::Default::CommandLineSettings::SettingsFilePath)
                writeSettingsFile
            end

            information = Settings.from_json(File.read("/"+ISM::Default::CommandLineSettings::SettingsFilePath))

            #Generic parameters
            @secureMode = information.secureMode
            @installByChroot = information.installByChroot
            @rootPath = information.rootPath
            @defaultMirror = information.defaultMirror

            #Host related parameters
            @targetName = information.targetName
            @architecture = information.architecture
            @target = information.target
            @makeOptions = information.makeOptions
            @buildOptions = information.buildOptions
            @name = information.name
            @fullName = information.fullName
            @id = information.id
            @release = information.release
            @codeName = information.codeName
            @description = information.description
            @version = information.version
            @ansiColor = information.ansiColor
            @cpeName = information.cpeName
            @homeUrl = information.homeUrl
            @supportUrl = information.supportUrl
            @bugReportUrl = information.bugReportUrl
            @privacyPolicyUrl = information.privacyPolicyUrl
            @buildId = information.buildId
            @variant = information.variant
            @variantId = information.variantId

            #Chroot related parameters
            @chrootTargetName = information.chrootTargetName
            @chrootArchitecture = information.chrootArchitecture
            @chrootTarget = information.chrootTarget
            @chrootMakeOptions = information.chrootMakeOptions
            @chrootBuildOptions = information.chrootBuildOptions
            @chrootName = information.chrootName
            @chrootFullName = information.chrootFullName
            @chrootId = information.chrootId
            @chrootRelease = information.chrootRelease
            @chrootCodeName = information.chrootCodeName
            @chrootDescription = information.chrootDescription
            @chrootVersion = information.chrootVersion
            @chrootAnsiColor = information.chrootAnsiColor
            @chrootCpeName = information.chrootCpeName
            @chrootHomeUrl = information.chrootHomeUrl
            @chrootSupportUrl = information.chrootSupportUrl
            @chrootBugReportUrl = information.chrootBugReportUrl
            @chrootPrivacyPolicyUrl = information.chrootPrivacyPolicyUrl
            @chrootBuildId = information.chrootBuildId
            @chrootVariant = information.chrootVariant
            @chrootVariantId = information.chrootVariantId
        end

        def writeSettings(  #Generic parameters
                            secureMode : Bool,
                            installByChroot : Bool,
                            rootPath : String,
                            defaultMirror : String,

                            #Host related parameters
                            targetName : String,
                            architecture : String,
                            target : String,
                            makeOptions : String,
                            buildOptions : String,
                            name : String,
                            fullName : String,
                            id : String,
                            release : String,
                            codeName : String,
                            description : String,
                            version : String,
                            ansiColor : String,
                            cpeName : String,
                            homeUrl : String,
                            supportUrl : String,
                            bugReportUrl : String,
                            privacyPolicyUrl : String,
                            buildId : String,
                            variant : String,
                            variantId : String,

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
                            chrootAnsiColor : String,
                            chrootCpeName : String,
                            chrootHomeUrl : String,
                            chrootSupportUrl : String,
                            chrootBugReportUrl : String,
                            chrootPrivacyPolicyUrl : String,
                            chrootBuildId : String,
                            chrootVariant : String,
                            chrootVariantId : String)

            path = filePath.chomp(filePath[filePath.rindex("/")..-1])

            if !Dir.exists?(path)
                Dir.mkdir_p(path)
            end

            settings = Settings.new(#Generic parameters
                                    secureMode,
                                    installByChroot,
                                    rootPath,
                                    defaultMirror,

                                    #Host related parameters
                                    targetName,
                                    architecture,
                                    target,
                                    makeOptions,
                                    buildOptions,
                                    name,
                                    fullName,
                                    id,
                                    release,
                                    codeName,
                                    description,
                                    version,
                                    ansiColor,
                                    cpeName,
                                    homeUrl,
                                    supportUrl,
                                    bugReportUrl,
                                    privacyPolicyUrl,
                                    buildId,
                                    variant,
                                    variantId,

                                    #Chroot related parameters
                                    chrootTargetName,
                                    chrootArchitecture,
                                    chrootTarget,
                                    chrootMakeOptions,
                                    chrootBuildOptions,
                                    chrootName,
                                    chrootFullName,
                                    chrootId,
                                    chrootRelease,
                                    chrootCodeName,
                                    chrootDescription,
                                    chrootVersion,
                                    chrootAnsiColor,
                                    chrootCpeName,
                                    chrootHomeUrl,
                                    chrootSupportUrl,
                                    chrootBugReportUrl,
                                    chrootPrivacyPolicyUrl,
                                    chrootBuildId,
                                    chrootVariant,
                                    chrootVariantId)


            file = File.open(filePath,"w")
            settings.to_json(file)
            file.close
        end

        def writeChrootSettingsFile
            writeSettings(  #File path
                            @rootPath+ISM::Default::CommandLineSettings::SettingsFilePath,
                            #Generic parameters
                            ISM::Default::CommandLineSettings::SecureMode,
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
                            ISM::Default::CommandLineSettings::TargetName ,
                            ISM::Default::CommandLineSettings::Architecture,
                            ISM::Default::CommandLineSettings::Target,
                            ISM::Default::CommandLineSettings::MakeOptions,
                            ISM::Default::CommandLineSettings::BuildOptions,
                            ISM::Default::CommandLineSettings::Name,
                            ISM::Default::CommandLineSettings::FullName,
                            ISM::Default::CommandLineSettings::Id,
                            ISM::Default::CommandLineSettings::Release,
                            ISM::Default::CommandLineSettings::CodeName,
                            ISM::Default::CommandLineSettings::Description,
                            ISM::Default::CommandLineSettings::Version,
                            ISM::Default::CommandLineSettings::AnsiColor,
                            ISM::Default::CommandLineSettings::CpeName,
                            ISM::Default::CommandLineSettings::HomeUrl,
                            ISM::Default::CommandLineSettings::SupportUrl,
                            ISM::Default::CommandLineSettings::BugReportUrl,
                            ISM::Default::CommandLineSettings::PrivacyPolicyUrl,
                            ISM::Default::CommandLineSettings::BuildId,
                            ISM::Default::CommandLineSettings::Variant,
                            ISM::Default::CommandLineSettings::VariantId)
        end

        def writeSettingsFile
            writeSettings(  #File path
                            "/"+ISM::Default::CommandLineSettings::SettingsFilePath,
                            #Generic parameters
                            @secureMode,
                            @installByChroot,
                            @rootPath,
                            @defaultMirror,

                            #Host related parameters
                            @targetName,
                            @architecture,
                            @target,
                            @makeOptions,
                            @buildOptions,
                            @name,
                            @fullName,
                            @id,
                            @release,
                            @codeName,
                            @description,
                            @version,
                            @ansiColor,
                            @cpeName,
                            @homeUrl,
                            @supportUrl,
                            @bugReportUrl,
                            @privacyPolicyUrl,
                            @buildId,
                            @variant,
                            @variantId,

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
                writeChrootSettingsFile
            end
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

        def name(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootName : @name)
            else
                return @name
            end
        end

        def targetName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTargetName : @targetName)
            else
                return @targetName
            end
        end

        def architecture(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootArchitecture : @architecture)
            else
                return @architecture
            end
        end

        def target(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTarget : @target)
            else
                return @target
            end
        end

        def makeOptions(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootMakeOptions : @makeOptions)
            else
                return @makeOptions
            end
        end

        def buildOptions(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBuildOptions : @buildOptions)
            else
                return @buildOptions
            end
        end

        #Setter methods

        #   Generic
        def setSecureMode(@secureMode)
            writeSettingsFile
        end

        def setInstallByChroot(@installByChroot)
            writeSettingsFile
        end

        def setRootPath(@rootPath)
            writeSettingsFile
        end

        def setDefaultMirror(@defaultMirror)
            writeSettingsFile
        end

        #   Host
        def setTargetName(@targetName)
            writeSettingsFile
            setTarget
        end

        def setArchitecture(@architecture)
            writeSettingsFile
            setTarget
        end

        def setTarget
            @target = @architecture + "-" + @targetName + "-" + "linux-gnu"
            writeSettingsFile
        end

        def setMakeOptions(@makeOptions)
            match,invalidValue = Ism.inputMatchWithFilter(@makeOptions,ISM::Default::CommandLineSettings::MakeOptionsFilter)

            if match
                writeSettingsFile
            else
                puts "#{ISM::Default::CommandLineSettings::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                puts "#{ISM::Default::CommandLineSettings::ErrorMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                Ism.exitProgram
            end
        end

        def setBuildOptions(@buildOptions)
            writeSettingsFile
        end

        def setName(@name)
            writeSettingsFile
        end

        def setFullName(@fullName)
            writeSettingsFile
        end

        def setId(@id)
            writeSettingsFile
        end

        def setRelease(@release)
            writeSettingsFile
        end

        def setCodeName(@codeName)
            writeSettingsFile
        end

        def setDescription(@description)
            writeSettingsFile
        end

        def setVersion(@version)
            writeSettingsFile
        end

        def setAnsiColor(@ansiColor)
            writeSettingsFile
        end

        def setCpeName(@cpeName)
            writeSettingsFile
        end

        def setHomeUrl(@homeUrl)
            writeSettingsFile
        end

        def setSupportUrl(@supportUrl)
            writeSettingsFile
        end

        def setBugReportUrl(@bugReportUrl)
            writeSettingsFile
        end

        def setPrivacyPolicyUrl(@privacyPolicyUrl)
            writeSettingsFile
        end

        def setBuildId(@buildId)
            writeSettingsFile
        end

        def setVariant(@variant)
            writeSettingsFile
        end

        def setVariantId(@variantId)
            writeSettingsFile
        end

        #   Chroot
        def setChrootTargetName(@chrootTargetName)
            writeSettingsFile
        end

        def setChrootArchitecture(@chrootArchitecture)
            writeSettingsFile
        end

        def setChrootTarget(@chrootTarget)
            writeSettingsFile
        end

        def setChrootMakeOptions(@chrootMakeOptions)
            match,invalidValue = Ism.inputMatchWithFilter(@chrootMakeOptions,ISM::Default::CommandLineSettings::ChrootMakeOptionsFilter)

            if match
                writeSettingsFile
            else
                puts "#{ISM::Default::CommandLineSettings::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                puts "#{ISM::Default::CommandLineSettings::ErrorChrootMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                Ism.exitProgram
            end
        end

        def setChrootBuildOptions(@chrootBuildOptions)
            writeSettingsFile
        end

        def setChrootName(@chrootName)
            writeSettingsFile
        end


        def setChrootFullName(@chrootFullName)
            writeSettingsFile
        end

        def setChrootId(@chrootId)
            writeSettingsFile
        end

        def setChrootRelease(@chrootRelease)
            writeSettingsFile
        end

        def setChrootCodeName(@chrootCodeName)
            writeSettingsFile
        end

        def setChrootDescription(@chrootDescription)
            writeSettingsFile
        end

        def setChrootVersion(@chrootVersion)
            writeSettingsFile
        end

        def setChrootAnsiColor(@chrootAnsiColor)
            writeSettingsFile
        end

        def setChrootCpeName(@chrootCpeName)
            writeSettingsFile
        end

        def setChrootHomeUrl(@chrootHomeUrl)
            writeSettingsFile
        end

        def setChrootSupportUrl(@chrootSupportUrl)
            writeSettingsFile
        end

        def setChrootBugReportUrl(@chrootBugReportUrl)
            writeSettingsFile
        end

        def setChrootPrivacyPolicyUrl(@chrootPrivacyPolicyUrl)
            writeSettingsFile
        end

        def setChrootBuildId(@chrootBuildId)
            writeSettingsFile
        end

        def setChrootVariant(@chrootVariant)
            writeSettingsFile
        end

        def setChrootVariantId(@chrootVariantId)
            writeSettingsFile
        end

    end

end
