module ISM

    module Option

        class Settings

            class Show < CommandLine::Option

                module Default

                    ShortText = "-s"
                    LongText = "show"
                    Description = "Show the current settings"
                    TitleText = "Current ISM settings"

                    #Generic titles
                    GlobalText = "(Global)"
                    RootPathText = "Root path"
                    ToolsPathText = "Tools path"
                    SourcesPathText = "Sources path"

                    #Host titles
                    SystemText = "(System)"
                    DefaultMirrorText = "Default mirror"
                    AutoBuildKernel = "Auto build the kernel"
                    BuildKernelOptionsAsModule = "Build kernel options as module"
                    AutoDeployServicesText = "Auto deploy services"
                    MakeOptionsText = "Make options"
                    BuildOptionsText = "Build options"
                    SystemTargetArchitectureText = "System target architecture"
                    SystemTargetVendorText = "System target vendor"
                    SystemTargetOsText = "System target OS"
                    SystemTargetAbiText = "System target ABI"
                    SystemTargetText = "System target"
                    SystemNameText = "System name"
                    SystemFullNameText = "System full name"
                    SystemIdText = "System id"
                    SystemReleaseText = "System release"
                    SystemCodeNameText = "System code name"
                    SystemDescriptionText = "System description"
                    SystemVersionText = "System version"
                    SystemVersionIdText = "System version ID"
                    SystemAnsiColorText = "System ANSI color"
                    SystemCpeNameText = "System CPE name"
                    SystemHomeUrlText = "System home url"
                    SystemSupportUrlText = "System support url"
                    SystemBugReportUrlText = "System report url"
                    SystemPrivacyPolicyUrlText = "System privacy policy url"
                    SystemBuildIdText = "System build ID"
                    SystemVariantText = "System variant"
                    SystemVariantIdText = "System variant ID"

                    #Chroot title
                    ChrootText = "(Chroot)"
                    ChrootDefaultMirrorText = "Chroot Default mirror"
                    ChrootAutoBuildKernel = "Chroot Auto build the kernel"
                    ChrootBuildKernelOptionsAsModule = "Chroot Build kernel options as module"
                    ChrootAutoDeployServicesText = "Chroot Auto deploy services"
                    ChrootMakeOptionsText = "Chroot make options"
                    ChrootBuildOptionsText = "Chroot build options"
                    ChrootSystemTargetArchitectureText = "Chroot target architecture"
                    ChrootSystemTargetVendorText = "Chroot target vendor"
                    ChrootSystemTargetOsText = "Chroot target OS"
                    ChrootSystemTargetAbiText = "Chroot target ABI"
                    ChrootSystemTargetText = "Chroot target"
                    ChrootSystemNameText = "Chroot name"
                    ChrootSystemFullNameText = "Chroot full name"
                    ChrootSystemIdText = "Chroot id"
                    ChrootSystemReleaseText = "Chroot release"
                    ChrootSystemCodeNameText = "Chroot code name"
                    ChrootSystemDescriptionText = "Chroot description"
                    ChrootSystemVersionText = "Chroot version"
                    ChrootSystemVersionIdText = "Chroot version ID"
                    ChrootSystemAnsiColorText = "Chroot ANSI color"
                    ChrootSystemCpeNameText = "Chroot CPE name"
                    ChrootSystemHomeUrlText = "Chroot home url"
                    ChrootSystemSupportUrlText = "Chroot support url"
                    ChrootSystemBugReportUrlText = "Chroot report url"
                    ChrootSystemPrivacyPolicyUrlText = "Chroot privacy policy url"
                    ChrootSystemBuildIdText = "Chroot build ID"
                    ChrootSystemVariantText = "Chroot variant"
                    ChrootSystemVariantIdText = "Chroot variant ID"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    puts "#{Default::TitleText}:".colorize(:yellow)
                    puts "\t#{Default::GlobalText}".colorize(:green)
                    puts "\t#{Default::RootPathText}: #{Ism.settings.rootPath.colorize(:green)}"
                    puts "\t#{Default::ToolsPathText}: #{Ism.settings.toolsPath.colorize(:green)}"
                    puts "\t#{Default::SourcesPathText}: #{Ism.settings.sourcesPath.colorize(:green)}"
                    puts "\t#{Default::SystemText}".colorize(:green)
                    puts "\t#{Default::DefaultMirrorText}: #{Ism.settings.defaultMirror.colorize(:green)}"
                    puts "\t#{Default::BuildKernelOptionsAsModule}: #{Ism.settings.buildKernelOptionsAsModule.colorize(:green)}"
                    puts "\t#{Default::AutoBuildKernel}: #{Ism.settings.autoBuildKernel.colorize(:green)}"
                    puts "\t#{Default::AutoDeployServicesText}: #{Ism.settings.autoDeployServices.colorize(:green)}"
                    puts "\t#{Default::MakeOptionsText}: #{Ism.settings.makeOptions(false).colorize(:green)}"
                    puts "\t#{Default::BuildOptionsText}: #{Ism.settings.buildOptions(false).colorize(:green)}"
                    puts "\t#{Default::SystemTargetArchitectureText}: #{Ism.settings.systemTargetArchitecture(false).colorize(:green)}"
                    puts "\t#{Default::SystemTargetVendorText}: #{Ism.settings.systemTargetVendor(false).colorize(:green)}"
                    puts "\t#{Default::SystemTargetOsText}: #{Ism.settings.systemTargetOs(false).colorize(:green)}"
                    puts "\t#{Default::SystemTargetAbiText}: #{Ism.settings.systemTargetAbi(false).colorize(:green)}"
                    puts "\t#{Default::SystemTargetText}: #{Ism.settings.systemTarget(false).colorize(:green)}"
                    puts "\t#{Default::SystemNameText}: #{Ism.settings.systemName(false).colorize(:green)}"
                    puts "\t#{Default::SystemFullNameText}: #{Ism.settings.systemFullName(false).colorize(:green)}"
                    puts "\t#{Default::SystemIdText}: #{Ism.settings.systemId(false).colorize(:green)}"
                    puts "\t#{Default::SystemReleaseText}: #{Ism.settings.systemRelease(false).colorize(:green)}"
                    puts "\t#{Default::SystemCodeNameText}: #{Ism.settings.systemCodeName(false).colorize(:green)}"
                    puts "\t#{Default::SystemDescriptionText}: #{Ism.settings.systemDescription(false).colorize(:green)}"
                    puts "\t#{Default::SystemVersionText}: #{Ism.settings.systemVersion(false).colorize(:green)}"
                    puts "\t#{Default::SystemVersionIdText}: #{Ism.settings.systemVersionId(false).colorize(:green)}"
                    puts "\t#{Default::SystemAnsiColorText}: #{Ism.settings.systemAnsiColor(false).colorize(:green)}"
                    puts "\t#{Default::SystemCpeNameText}: #{Ism.settings.systemCpeName(false).colorize(:green)}"
                    puts "\t#{Default::SystemHomeUrlText}: #{Ism.settings.systemHomeUrl(false).colorize(:green)}"
                    puts "\t#{Default::SystemSupportUrlText}: #{Ism.settings.systemSupportUrl(false).colorize(:green)}"
                    puts "\t#{Default::SystemBugReportUrlText}: #{Ism.settings.systemBugReportUrl(false).colorize(:green)}"
                    puts "\t#{Default::SystemPrivacyPolicyUrlText}: #{Ism.settings.systemPrivacyPolicyUrl(false).colorize(:green)}"
                    puts "\t#{Default::SystemBuildIdText}: #{Ism.settings.systemBuildId(false).colorize(:green)}"
                    puts "\t#{Default::SystemVariantText}: #{Ism.settings.systemVariant(false).colorize(:green)}"
                    puts "\t#{Default::SystemVariantIdText}: #{Ism.settings.systemVariantId(false).colorize(:green)}"
                    puts "\t#{Default::ChrootText}".colorize(:green)
                    puts "\t#{Default::ChrootDefaultMirrorText}: #{Ism.settings.chrootDefaultMirror.colorize(:green)}"
                    puts "\t#{Default::ChrootBuildKernelOptionsAsModule}: #{Ism.settings.chrootBuildKernelOptionsAsModule.colorize(:green)}"
                    puts "\t#{Default::ChrootAutoBuildKernel}: #{Ism.settings.chrootAutoBuildKernel.colorize(:green)}"
                    puts "\t#{Default::ChrootAutoDeployServicesText}: #{Ism.settings.chrootAutoDeployServices.colorize(:green)}"
                    puts "\t#{Default::ChrootMakeOptionsText}: #{Ism.settings.chrootMakeOptions.colorize(:green)}"
                    puts "\t#{Default::ChrootBuildOptionsText}: #{Ism.settings.chrootBuildOptions.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemTargetArchitectureText}: #{Ism.settings.chrootSystemTargetArchitecture.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemTargetVendorText}: #{Ism.settings.chrootSystemTargetVendor.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemTargetOsText}: #{Ism.settings.chrootSystemTargetOs.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemTargetAbiText}: #{Ism.settings.chrootSystemTargetAbi.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemTargetText}: #{Ism.settings.chrootSystemTarget.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemNameText}: #{Ism.settings.chrootSystemName.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemFullNameText}: #{Ism.settings.chrootSystemFullName.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemIdText}: #{Ism.settings.chrootSystemId.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemReleaseText}: #{Ism.settings.chrootSystemRelease.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemCodeNameText}: #{Ism.settings.chrootSystemCodeName.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemDescriptionText}: #{Ism.settings.chrootSystemDescription.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemVersionText}: #{Ism.settings.chrootSystemVersion.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemVersionIdText}: #{Ism.settings.chrootSystemVersionId.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemAnsiColorText}: #{Ism.settings.chrootSystemAnsiColor.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemCpeNameText}: #{Ism.settings.chrootSystemCpeName.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemHomeUrlText}: #{Ism.settings.chrootSystemHomeUrl.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemSupportUrlText}: #{Ism.settings.chrootSystemSupportUrl.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemBugReportUrlText}: #{Ism.settings.chrootSystemBugReportUrl.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemPrivacyPolicyUrlText}: #{Ism.settings.chrootSystemPrivacyPolicyUrl.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemBuildIdText}: #{Ism.settings.chrootSystemBuildId.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemVariantText}: #{Ism.settings.chrootSystemVariant.colorize(:green)}"
                    puts "\t#{Default::ChrootSystemVariantIdText}: #{Ism.settings.chrootSystemVariantId.colorize(:green)}"
                end

            end

        end

    end

end
