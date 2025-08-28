module ISM

    module Path

        IsmDirectory = "ism/"
        BinaryDirectory = "bin/"
        ToolsDirectory = "tools/"
        SourcesDirectory = "sources/"
        RuntimeDataDirectory = "var/#{IsmDirectory}"
        TemporaryDirectory = "tmp/#{IsmDirectory}"
        LogsDirectory = "var/log/#{IsmDirectory}"
        LibraryDirectory = "usr/lib/#{IsmDirectory}"
        SettingsDirectory = "#{RuntimeDataDirectory}settings/"
        PortsDirectory = "#{RuntimeDataDirectory}ports/"
        KernelOptionsDirectory = "#{RuntimeDataDirectory}kerneloptions/"
        NeededKernelOptionsDirectory = "#{RuntimeDataDirectory}neededkerneloptions/"
        SoftwaresDirectory = "#{RuntimeDataDirectory}softwares/"
        InstalledSoftwaresDirectory = "#{RuntimeDataDirectory}installedsoftwares/"
        SettingsSoftwaresDirectory = "#{SettingsDirectory}softwares/"
        BuiltSoftwaresDirectory = "#{TemporaryDirectory}builtsoftwares/"
        MirrorsDirectory = "#{RuntimeDataDirectory}mirrors/"
        PatchesDirectory = "#{RuntimeDataDirectory}patches/"
        FavouriteGroupsDirectory = "#{RuntimeDataDirectory}favouritegroups/"

    end

end
