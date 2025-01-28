module ISM

    module Default

        module Option

            module Settings

                ShortText = "-se"
                LongText = "settings"
                Description = "Configure ISM settings"
                Options = [ ISM::Option::SettingsShow.new,
                            #Global options
                            ISM::Option::SettingsEnableSecureMode.new,
                            ISM::Option::SettingsDisableSecureMode.new,
                            ISM::Option::SettingsEnableBinaryTaskMode.new,
                            ISM::Option::SettingsDisableBinaryTaskMode.new,
                            ISM::Option::SettingsEnableInstallByChroot.new,
                            ISM::Option::SettingsDisableInstallByChroot.new,
                            ISM::Option::SettingsSetRootPath.new,
                            ISM::Option::SettingsSetDefaultMirror.new,
                            ISM::Option::SettingsEnableBuildKernelOptionsAsModule.new,
                            ISM::Option::SettingsDisableBuildKernelOptionsAsModule.new,
                            #Host options
                            ISM::Option::SettingsSetSystemTargetName.new,
                            ISM::Option::SettingsSetSystemArchitecture.new,
                            ISM::Option::SettingsSetSystemMakeOptions.new,
                            ISM::Option::SettingsSetSystemBuildOptions.new,
                            ISM::Option::SettingsSetSystemName.new,
                            ISM::Option::SettingsSetSystemFullName.new,
                            ISM::Option::SettingsSetSystemId.new,
                            ISM::Option::SettingsSetSystemRelease.new,
                            ISM::Option::SettingsSetSystemCodeName.new,
                            ISM::Option::SettingsSetSystemDescription.new,
                            ISM::Option::SettingsSetSystemVersion.new,
                            ISM::Option::SettingsSetSystemVersionId.new,
                            ISM::Option::SettingsSetSystemAnsiColor.new,
                            ISM::Option::SettingsSetSystemCpeName.new,
                            ISM::Option::SettingsSetSystemHomeUrl.new,
                            ISM::Option::SettingsSetSystemSupportUrl.new,
                            ISM::Option::SettingsSetSystemBugReportUrl.new,
                            ISM::Option::SettingsSetSystemPrivacyPolicyUrl.new,
                            ISM::Option::SettingsSetSystemBuildId.new,
                            ISM::Option::SettingsSetSystemVariant.new,
                            ISM::Option::SettingsSetSystemVariantId.new,
                            #Chroot options
                            ISM::Option::SettingsSetChrootTargetName.new,
                            ISM::Option::SettingsSetChrootArchitecture.new,
                            ISM::Option::SettingsSetChrootMakeOptions.new,
                            ISM::Option::SettingsSetChrootBuildOptions.new,
                            ISM::Option::SettingsSetChrootName.new,
                            ISM::Option::SettingsSetChrootFullName.new,
                            ISM::Option::SettingsSetChrootId.new,
                            ISM::Option::SettingsSetChrootRelease.new,
                            ISM::Option::SettingsSetChrootCodeName.new,
                            ISM::Option::SettingsSetChrootDescription.new,
                            ISM::Option::SettingsSetChrootVersion.new,
                            ISM::Option::SettingsSetChrootVersionId.new,
                            ISM::Option::SettingsSetChrootAnsiColor.new,
                            ISM::Option::SettingsSetChrootCpeName.new,
                            ISM::Option::SettingsSetChrootHomeUrl.new,
                            ISM::Option::SettingsSetChrootSupportUrl.new,
                            ISM::Option::SettingsSetChrootBugReportUrl.new,
                            ISM::Option::SettingsSetChrootPrivacyPolicyUrl.new,
                            ISM::Option::SettingsSetChrootBuildId.new,
                            ISM::Option::SettingsSetChrootVariant.new,
                            ISM::Option::SettingsSetChrootVariantId.new]

            end
        end

    end

end
