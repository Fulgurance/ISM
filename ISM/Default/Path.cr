module ISM

    module Default

        module Path
            
            IsmDirectory = "ism/"
            BinaryDirectory = "bin/"
            ToolsDirectory = "tools/"
            SourcesDirectory = "sources/"
            RuntimeDataDirectory = "var/#{IsmDirectory}"
            TemporaryDirectory = "tmp/#{IsmDirectory}"
            SettingsDirectory = "etc/#{IsmDirectory}"
            LogsDirectory = "var/log/#{IsmDirectory}"
            LibraryDirectory = "usr/share/#{IsmDirectory}"
            PortsDirectory = "#{RuntimeDataDirectory}ports/"
            SoftwaresDirectory = "#{RuntimeDataDirectory}softwares/"
            InstalledSoftwaresDirectory = "#{RuntimeDataDirectory}installedsoftwares/"
            KernelOptionsDirectory = "#{RuntimeDataDirectory}kerneloptions/"
            SettingsSoftwaresDirectory = "#{SettingsDirectory}softwares/"
            BuiltSoftwaresDirectory = "#{TemporaryDirectory}builtsoftwares/"
            MirrorsDirectory = "#{RuntimeDataDirectory}mirrors/"

        end

    end

end
