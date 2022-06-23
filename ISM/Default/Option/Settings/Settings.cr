module ISM

    module Default

        module Option

            module Settings

                ShortText = "-se"
                LongText = "settings"
                Description = "Configure ISM settings"
                Options = [ ISM::Option::SettingsShow.new,
                            ISM::Option::SettingsSetArchitecture.new,
                            ISM::Option::SettingsSetBuildOptions.new,
                            ISM::Option::SettingsSetMakeOptions.new,
                            ISM::Option::SettingsSetRootPath.new,
                            ISM::Option::SettingsSetSourcesPath.new,
                            ISM::Option::SettingsSetSystemName.new,
                            ISM::Option::SettingsSetTargetName.new,
                            ISM::Option::SettingsSetToolsPath.new]

            end
        end

    end

end
