module ISM

    module Option

        class SettingsShow < ISM::CommandLineOption

            module Default

                ShortText = "-s"
                LongText = "show"
                Description = "Show the current settings"
                TitleText = "Current ISM settings"

                #Generic titles
                ToolsPathText = "Tools path"
                SourcesPathText = "Sources path"
                RootPathText = "Root path"
                DefaultMirrorText = "Default mirror"
                AutoBuildKernel = "Auto build the kernel"
                BuildKernelOptionsAsModule = "Build kernel options as module"
                AutoDeployServicesText = "Auto deploy services"

                #Host titles
                SystemTargetNameText = "System target name"
                SystemArchitectureText = "System architecture"
                SystemTargetText = "System target"
                SystemMakeOptionsText = "System make options"
                SystemBuildOptionsText = "System build options"
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
                ChrootTargetNameText = "Chroot target name"
                ChrootArchitectureText = "Chroot architecture"
                ChrootTargetText = "Chroot target"
                ChrootMakeOptionsText = "Chroot make options"
                ChrootBuildOptionsText = "Chroot build options"
                ChrootNameText = "Chroot name"
                ChrootFullNameText = "Chroot full name"
                ChrootIdText = "Chroot id"
                ChrootReleaseText = "Chroot release"
                ChrootCodeNameText = "Chroot code name"
                ChrootDescriptionText = "Chroot description"
                ChrootVersionText = "Chroot version"
                ChrootVersionIdText = "Chroot version ID"
                ChrootAnsiColorText = "Chroot ANSI color"
                ChrootCpeNameText = "Chroot CPE name"
                ChrootHomeUrlText = "Chroot home url"
                ChrootSupportUrlText = "Chroot support url"
                ChrootBugReportUrlText = "Chroot report url"
                ChrootPrivacyPolicyUrlText = "Chroot privacy policy url"
                ChrootBuildIdText = "Chroot build ID"
                ChrootVariantText = "Chroot variant"
                ChrootVariantIdText = "Chroot variant ID"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                puts "#{Default::TitleText}:".colorize(:yellow)

                puts "\t#{Default::RootPathText}: #{Ism.settings.rootPath.colorize(:green)}"
                puts "\t#{Default::DefaultMirrorText}: #{Ism.settings.defaultMirror.colorize(:green)}"
                puts "\t#{Default::BuildKernelOptionsAsModule}: #{Ism.settings.buildKernelOptionsAsModule.colorize(:green)}"
                puts "\t#{Default::AutoBuildKernel}: #{Ism.settings.autoBuildKernel.colorize(:green)}"
                puts "\t#{Default::AutoDeployServicesText}: #{Ism.settings.autoDeployServices.colorize(:green)}"

                puts "\t#{Default::SystemTargetNameText}: #{Ism.settings.systemTargetName(false).colorize(:green)}"
                puts "\t#{Default::SystemArchitectureText}: #{Ism.settings.systemArchitecture(false).colorize(:green)}"
                puts "\t#{Default::SystemTargetText}: #{Ism.settings.systemTarget(false).colorize(:green)}"
                puts "\t#{Default::SystemMakeOptionsText}: #{Ism.settings.systemMakeOptions(false).colorize(:green)}"
                puts "\t#{Default::SystemBuildOptionsText}: #{Ism.settings.systemBuildOptions(false).colorize(:green)}"
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

                puts "\t=========================".colorize(:green)

                puts "\t#{Default::ChrootTargetNameText}: #{Ism.settings.chrootTargetName.colorize(:green)}"
                puts "\t#{Default::ChrootArchitectureText}: #{Ism.settings.chrootArchitecture.colorize(:green)}"
                puts "\t#{Default::ChrootTargetText}: #{Ism.settings.chrootTarget.colorize(:green)}"
                puts "\t#{Default::ChrootMakeOptionsText}: #{Ism.settings.chrootMakeOptions.colorize(:green)}"
                puts "\t#{Default::ChrootBuildOptionsText}: #{Ism.settings.chrootBuildOptions.colorize(:green)}"
                puts "\t#{Default::ChrootNameText}: #{Ism.settings.chrootName.colorize(:green)}"
                puts "\t#{Default::ChrootFullNameText}: #{Ism.settings.chrootFullName.colorize(:green)}"
                puts "\t#{Default::ChrootIdText}: #{Ism.settings.chrootId.colorize(:green)}"
                puts "\t#{Default::ChrootReleaseText}: #{Ism.settings.chrootRelease.colorize(:green)}"
                puts "\t#{Default::ChrootCodeNameText}: #{Ism.settings.chrootCodeName.colorize(:green)}"
                puts "\t#{Default::ChrootDescriptionText}: #{Ism.settings.chrootDescription.colorize(:green)}"
                puts "\t#{Default::ChrootVersionText}: #{Ism.settings.chrootVersion.colorize(:green)}"
                puts "\t#{Default::ChrootVersionIdText}: #{Ism.settings.chrootVersionId.colorize(:green)}"
                puts "\t#{Default::ChrootAnsiColorText}: #{Ism.settings.chrootAnsiColor.colorize(:green)}"
                puts "\t#{Default::ChrootCpeNameText}: #{Ism.settings.chrootCpeName.colorize(:green)}"
                puts "\t#{Default::ChrootHomeUrlText}: #{Ism.settings.chrootHomeUrl.colorize(:green)}"
                puts "\t#{Default::ChrootSupportUrlText}: #{Ism.settings.chrootSupportUrl.colorize(:green)}"
                puts "\t#{Default::ChrootBugReportUrlText}: #{Ism.settings.chrootBugReportUrl.colorize(:green)}"
                puts "\t#{Default::ChrootPrivacyPolicyUrlText}: #{Ism.settings.chrootPrivacyPolicyUrl.colorize(:green)}"
                puts "\t#{Default::ChrootBuildIdText}: #{Ism.settings.chrootBuildId.colorize(:green)}"
                puts "\t#{Default::ChrootVariantText}: #{Ism.settings.chrootVariant.colorize(:green)}"
                puts "\t#{Default::ChrootVariantIdText}: #{Ism.settings.chrootVariantId.colorize(:green)}"
            end

        end

    end

end
