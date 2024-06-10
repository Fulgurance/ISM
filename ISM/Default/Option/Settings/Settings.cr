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
                            ISM::Option::SettingsEnableInstallByChroot.new,
                            ISM::Option::SettingsDisableInstallByChroot.new,
                            ISM::Option::SettingsSetRootPath.new,
                            ISM::Option::SettingsSetDefaultMirror.new
                            #Host options
                            ISM::Option::SettingsSetTargetName.new,
                            ISM::Option::SettingsSetArchitecture.new,
                            ISM::Option::SettingsSetMakeOptions.new,
                            ISM::Option::SettingsSetBuildOptions.new,
                            ISM::Option::SettingsSetName.new,
                            ISM::Option::SettingsSetFullName.new,
                            ISM::Option::SettingsSetId.new,
                            ISM::Option::SettingsSetRelease.new,
                            ISM::Option::SettingsSetCodeName.new,
                            ISM::Option::SettingsSetDescription.new,
                            ISM::Option::SettingsSetVersion.new,
                            ISM::Option::SettingsSetAnsiColor.new,
                            ISM::Option::SettingsSetCpeName.new,
                            ISM::Option::SettingsSetHomeUrl.new,
                            ISM::Option::SettingsSetSupportUrl.new,
                            ISM::Option::SettingsSetBugReportUrl.new,
                            ISM::Option::SettingsSetPrivacyPolicyUrl.new,
                            ISM::Option::SettingsSetBuildId.new,
                            ISM::Option::SettingsSetVariant.new,
                            ISM::Option::SettingsSetVariantId.new,
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
