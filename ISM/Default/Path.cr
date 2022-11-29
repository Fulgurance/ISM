module ISM

    module Default

        module Path
            
            PortsDirectory = "Ports/"
            SettingsDirectory = "Settings/"
            IsmDirectory = "ISM/"
            SoftwaresDirectory = "Softwares/"
            InstalledSoftwaresDirectory = "InstalledSoftwares/"
            SettingsIsmDirectory = "#{SettingsDirectory}#{IsmDirectory}"
            SettingsSoftwaresDirectory = "#{SettingsDirectory}#{SoftwaresDirectory}/"
            TemporaryDirectory = "tmp/ism/"
            BuiltSoftwaresDirectory = "#{TemporaryDirectory}builtsoftwares/"
            ToolsDirectory = "tools/"
            SourcesDirectory = "sources/"

        end

    end

end
