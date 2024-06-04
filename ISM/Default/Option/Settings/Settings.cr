module ISM
  module Default
    module Option
      module Settings
        ShortText   = "-se"
        LongText    = "settings"
        Description = "Configure ISM settings"
        Options     = [ISM::Option::SettingsShow.new,
                       ISM::Option::SettingsEnableSecureMode.new,
                       ISM::Option::SettingsDisableSecureMode.new,
                       ISM::Option::SettingsEnableInstallByChroot.new,
                       ISM::Option::SettingsDisableInstallByChroot.new,
                       ISM::Option::SettingsSetRootPath.new,
                       ISM::Option::SettingsSetArchitecture.new,
                       ISM::Option::SettingsSetBuildOptions.new,
                       ISM::Option::SettingsSetMakeOptions.new,
                       ISM::Option::SettingsSetSystemName.new,
                       ISM::Option::SettingsSetTargetName.new,
                       ISM::Option::SettingsSetChrootArchitecture.new,
                       ISM::Option::SettingsSetChrootBuildOptions.new,
                       ISM::Option::SettingsSetChrootMakeOptions.new,
                       ISM::Option::SettingsSetChrootSystemName.new,
                       ISM::Option::SettingsSetChrootTargetName.new,
                       ISM::Option::SettingsSetDefaultMirror.new]
      end
    end
  end
end
