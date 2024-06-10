module ISM

    class CommandLineSettings

        record Settings,
            #Generic parameters
            secureMode : Bool,
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
            systemAnsiColor : String,
            systemCpeName : String,
            systemHomeUrl : String,
            systemSupportUrl : String,
            systemBugReportUrl : String,
            systemPrivacyPolicyUrl : String,
            systemBuildId : String,
            systemVariant : String,
            systemVariantId : String

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
                        @systemAnsiColor = ISM::Default::CommandLineSettings::SystemAnsiColor,
                        @systemCpeName = ISM::Default::CommandLineSettings::SystemCpeName,
                        @systemHomeUrl = ISM::Default::CommandLineSettings::SystemHomeUrl,
                        @systemSupportUrl = ISM::Default::CommandLineSettings::SystemSupportUrl,
                        @systemBugReportUrl = ISM::Default::CommandLineSettings::SystemBugReportUrl,
                        @systemPrivacyPolicyUrl = ISM::Default::CommandLineSettings::SystemPrivacyPolicyUrl,
                        @systemBuildId = ISM::Default::CommandLineSettings::SystemBuildId,
                        @systemVariant = ISM::Default::CommandLineSettings::SystemVariant,
                        @systemVariantId = ISM::Default::CommandLineSettings::SystemVariantId)

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
            @systemTargetName = information.systemTargetName
            @systemArchitecture = information.systemArchitecture
            @systemTarget = information.systemTarget
            @systemMakeOptions = information.systemMakeOptions
            @systemBuildOptions = information.systemBuildOptions
            @systemName = information.systemName
            @systemFullName = information.systemFullName
            @systemId = information.systemId
            @systemRelease = information.systemRelease
            @systemCodeName = information.systemCodeName
            @systemDescription = information.systemDescription
            @systemVersion = information.systemVersion
            @systemAnsiColor = information.systemAnsiColor
            @systemCpeName = information.systemCpeName
            @systemHomeUrl = information.systemHomeUrl
            @systemSupportUrl = information.systemSupportUrl
            @systemBugReportUrl = information.systemBugReportUrl
            @systemPrivacyPolicyUrl = information.systemPrivacyPolicyUrl
            @systemBuildId = information.systemBuildId
            @systemVariant = information.systemVariant
            @systemVariantId = information.systemVariantId

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
                            systemAnsiColor : String,
                            systemCpeName : String,
                            systemHomeUrl : String,
                            systemSupportUrl : String,
                            systemBugReportUrl : String,
                            systemPrivacyPolicyUrl : String,
                            systemBuildId : String,
                            systemVariant : String,
                            systemVariantId : String

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
                                    systemTargetName,
                                    systemArchitecture,
                                    systemTarget,
                                    systemMakeOptions,
                                    systemBuildOptions,
                                    systemName,
                                    systemFullName,
                                    systemId,
                                    systemRelease,
                                    systemCodeName,
                                    systemDescription,
                                    systemVersion,
                                    systemAnsiColor,
                                    systemCpeName,
                                    systemHomeUrl,
                                    systemSupportUrl,
                                    systemBugReportUrl,
                                    systemPrivacyPolicyUrl,
                                    systemBuildId,
                                    systemVariant,
                                    systemVariantId

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
                            ISM::Default::CommandLineSettings::SystemAnsiColor,
                            ISM::Default::CommandLineSettings::SystemCpeName,
                            ISM::Default::CommandLineSettings::SystemHomeUrl,
                            ISM::Default::CommandLineSettings::SystemSupportUrl,
                            ISM::Default::CommandLineSettings::SystemBugReportUrl,
                            ISM::Default::CommandLineSettings::SystemPrivacyPolicyUrl,
                            ISM::Default::CommandLineSettings::SystemBuildId,
                            ISM::Default::CommandLineSettings::SystemVariant,
                            ISM::Default::CommandLineSettings::SystemVariantId)
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
                            @systemAnsiColor,
                            @systemCpeName,
                            @systemHomeUrl,
                            @systemSupportUrl,
                            @systemBugReportUrl,
                            @systemPrivacyPolicyUrl,
                            @systemBuildId,
                            @systemVariant,
                            @systemVariantId

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

        def systemTargetName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTargetName : @systemTargetName)
            else
                return @systemTargetName
            end
        end

        def systemArchitecture(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootArchitecture : @systemArchitecture)
            else
                return @systemArchitecture
            end
        end

        def systemTarget(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootTarget : @systemTarget)
            else
                return @systemTarget
            end
        end

        def systemMakeOptions(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootMakeOptions : @systemMakeOptions)
            else
                return @systemMakeOptions
            end
        end

        def systemBuildOptions(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBuildOptions : @systemBuildOptions)
            else
                return @systemBuildOptions
            end
        end

        def systemName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootName : @systemName)
            else
                return @systemName
            end
        end

        def systemFullName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootFullName : @systemFullName)
            else
                return @systemFullName
            end
        end

        def systemId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootId : @systemId)
            else
                return @systemId
            end
        end

        def systemRelease(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootRelease : @systemRelease)
            else
                return @systemRelease
            end
        end

        def systemCodeName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootCodeName : @systemCodeName)
            else
                return @systemCodeName
            end
        end

        def systemDescription(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootDescription : @systemDescription)
            else
                return @systemDescription
            end
        end

        def systemVersion(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVersion : @systemVersion)
            else
                return @systemVersion
            end
        end

        def systemAnsiColor(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootAnsiColor : @systemAnsiColor)
            else
                return @systemAnsiColor
            end
        end

        def systemCpeName(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootCpeName : @systemCpeName)
            else
                return @systemCpeName
            end
        end

        def systemHomeUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootHomeUrl : @systemHomeUrl)
            else
                return @systemHomeUrl
            end
        end

        def systemSupportUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootSupportUrl : @systemSupportUrl)
            else
                return @systemSupportUrl
            end
        end

        def systemBugReportUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBugReportUrl : @systemBugReportUrl)
            else
                return @systemBugReportUrl
            end
        end

        def systemPrivacyPolicyUrl(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootPrivacyPolicyUrl : @systemPrivacyPolicyUrl)
            else
                return @systemPrivacyPolicyUrl
            end
        end

        def systemBuildId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootBuildId : @systemBuildId)
            else
                return @systemBuildId
            end
        end

        def systemVariant(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVariant : @systemVariant)
            else
                return @systemVariant
            end
        end

        def systemVariantId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVariantId : @systemVariantId)
            else
                return @systemVariantId
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
        def setSystemTargetName(@systemTargetName)
            writeSettingsFile
            setTarget
        end

        def setSystemArchitecture(@systemArchitecture)
            writeSettingsFile
            setTarget
        end

        def setSystemTarget
            @systemTarget = @systemArchitecture + "-" + @systemTargetName + "-" + "linux-gnu"
            writeSettingsFile
        end

        def setSystemMakeOptions(@systemMakeOptions)
            match,invalidValue = Ism.inputMatchWithFilter(@systemMakeOptions,ISM::Default::CommandLineSettings::MakeOptionsFilter)

            if match
                writeSettingsFile
            else
                puts "#{ISM::Default::CommandLineSettings::ErrorInvalidValueText.colorize(:red)}#{invalidValue.colorize(:red)}"
                puts "#{ISM::Default::CommandLineSettings::ErrorMakeOptionsInvalidValueAdviceText.colorize(:green)}"
                Ism.exitProgram
            end
        end

        def setSystemBuildOptions(@systemBuildOptions)
            writeSettingsFile
        end

        def setSystemName(@systemName)
            writeSettingsFile
        end

        def setSystemFullName(@systemFullName)
            writeSettingsFile
        end

        def setSystemId(@systemId)
            writeSettingsFile
        end

        def setSystemRelease(@systemRelease)
            writeSettingsFile
        end

        def setSystemCodeName(@systemCodeName)
            writeSettingsFile
        end

        def setSystemDescription(@systemDescription)
            writeSettingsFile
        end

        def setSystemVersion(@systemVersion)
            writeSettingsFile
        end

        def setSystemAnsiColor(@systemAnsiColor)
            writeSettingsFile
        end

        def setSystemCpeName(@systemCpeName)
            writeSettingsFile
        end

        def setSystemHomeUrl(@systemHomeUrl)
            writeSettingsFile
        end

        def setSystemSupportUrl(@systemSupportUrl)
            writeSettingsFile
        end

        def setSystemBugReportUrl(@systemBugReportUrl)
            writeSettingsFile
        end

        def setSystemPrivacyPolicyUrl(@systemPrivacyPolicyUrl)
            writeSettingsFile
        end

        def setSystemBuildId(@systemBuildId)
            writeSettingsFile
        end

        def setSystemVariant(@systemVariant)
            writeSettingsFile
        end

        def setSystemVariantId(@systemVariantId)
            writeSettingsFile
        end

        #   Chroot
        def setChrootTargetName(@chrootTargetName)
            writeSettingsFile
            setChrootTarget
        end

        def setChrootArchitecture(@chrootArchitecture)
            writeSettingsFile
        end

        def setChrootTarget
            @chrootTarget = @chootArchitecture + "-" + @chrootTargetName + "-" + "linux-gnu"
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
