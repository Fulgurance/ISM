module ISM

    class CommandLineSettings

        include JSON::Serializable

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
        end

        def self.generateConfiguration(path = filePath)
            file = File.open(path,"w")
            self.new.to_json
            file.close
        end

        def self.loadConfiguration(path = filePath)
            if !File.exists?(path)
                generateConfiguration(path)
            end

            return from_json(File.read(path))
        end

        def self.writeConfiguration(#File path
                                    path : String,

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
        end

        # def loadConfiguration(path = self.class.filePath)
        #     if !File.exists?(path)
        #         writeSystemConfiguration
        #     end
        #
        #     self = self.class.from_json(File.read(path))
        # end

        def writeChrootConfiguration
            self.class.writeConfiguration(  #File path
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
        end

        def writeSystemConfiguration
            self.class.writeConfiguration(  #File path
                                            self.class.filePath,

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

        def systemVersionId(relatedToChroot = true) : String
            if relatedToChroot
                return (@rootPath != "/" ? @chrootVersionId : @systemVersionId)
            else
                return @systemVersionId
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
            writeSystemConfiguration
        end

        def setInstallByChroot(@installByChroot)
            writeSystemConfiguration
        end

        def setRootPath(@rootPath)
            writeSystemConfiguration
        end

        def setDefaultMirror(@defaultMirror)
            writeSystemConfiguration
        end

        #   Host
        def setSystemTargetName(@systemTargetName)
            writeSystemConfiguration
            setSystemTarget
        end

        def setSystemArchitecture(@systemArchitecture)
            writeSystemConfiguration
            setSystemTarget
        end

        def setSystemTarget
            @systemTarget = @systemArchitecture + "-" + @systemTargetName + "-" + "linux-gnu"
            writeSystemConfiguration
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
        end

        def setSystemBuildOptions(@systemBuildOptions)
            writeSystemConfiguration
        end

        def setSystemName(@systemName)
            writeSystemConfiguration
        end

        def setSystemFullName(@systemFullName)
            writeSystemConfiguration
        end

        def setSystemId(@systemId)
            writeSystemConfiguration
        end

        def setSystemRelease(@systemRelease)
            writeSystemConfiguration
        end

        def setSystemCodeName(@systemCodeName)
            writeSystemConfiguration
        end

        def setSystemDescription(@systemDescription)
            writeSystemConfiguration
        end

        def setSystemVersion(@systemVersion)
            writeSystemConfiguration
        end

        def setSystemVersionId(@systemVersionId)
            writeSystemConfiguration
        end

        def setSystemAnsiColor(@systemAnsiColor)
            writeSystemConfiguration
        end

        def setSystemCpeName(@systemCpeName)
            writeSystemConfiguration
        end

        def setSystemHomeUrl(@systemHomeUrl)
            writeSystemConfiguration
        end

        def setSystemSupportUrl(@systemSupportUrl)
            writeSystemConfiguration
        end

        def setSystemBugReportUrl(@systemBugReportUrl)
            writeSystemConfiguration
        end

        def setSystemPrivacyPolicyUrl(@systemPrivacyPolicyUrl)
            writeSystemConfiguration
        end

        def setSystemBuildId(@systemBuildId)
            writeSystemConfiguration
        end

        def setSystemVariant(@systemVariant)
            writeSystemConfiguration
        end

        def setSystemVariantId(@systemVariantId)
            writeSystemConfiguration
        end

        #   Chroot
        def setChrootTargetName(@chrootTargetName)
            writeSystemConfiguration
            setChrootTarget
        end

        def setChrootArchitecture(@chrootArchitecture)
            writeSystemConfiguration
        end

        def setChrootTarget
            @chrootTarget = @chrootArchitecture + "-" + @chrootTargetName + "-" + "linux-gnu"
            writeSystemConfiguration
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
        end

        def setChrootBuildOptions(@chrootBuildOptions)
            writeSystemConfiguration
        end

        def setChrootName(@chrootName)
            writeSystemConfiguration
        end


        def setChrootFullName(@chrootFullName)
            writeSystemConfiguration
        end

        def setChrootId(@chrootId)
            writeSystemConfiguration
        end

        def setChrootRelease(@chrootRelease)
            writeSystemConfiguration
        end

        def setChrootCodeName(@chrootCodeName)
            writeSystemConfiguration
        end

        def setChrootDescription(@chrootDescription)
            writeSystemConfiguration
        end

        def setChrootVersion(@chrootVersion)
            writeSystemConfiguration
        end

        def setChrootVersionId(@chrootVersionId)
            writeSystemConfiguration
        end

        def setChrootAnsiColor(@chrootAnsiColor)
            writeSystemConfiguration
        end

        def setChrootCpeName(@chrootCpeName)
            writeSystemConfiguration
        end

        def setChrootHomeUrl(@chrootHomeUrl)
            writeSystemConfiguration
        end

        def setChrootSupportUrl(@chrootSupportUrl)
            writeSystemConfiguration
        end

        def setChrootBugReportUrl(@chrootBugReportUrl)
            writeSystemConfiguration
        end

        def setChrootPrivacyPolicyUrl(@chrootPrivacyPolicyUrl)
            writeSystemConfiguration
        end

        def setChrootBuildId(@chrootBuildId)
            writeSystemConfiguration
        end

        def setChrootVariant(@chrootVariant)
            writeSystemConfiguration
        end

        def setChrootVariantId(@chrootVariantId)
            writeSystemConfiguration
        end

    end

end
