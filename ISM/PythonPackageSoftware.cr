module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            runPipCommand(  arguments: "install '#{@information.name}==#{@information.version}'",
                            environment: {"PYTHONUSERBASE" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d")

            if File.exists?("#{Ism.settings.rootPath}etc/profile.d/python.sh")
                copyFile(   "/etc/profile.d/python.sh",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh")
            else
                generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh")
            end

            pythonData = <<-CODE
            pathappend /usr/lib/python3.13/site-packages/#{@information.name.downcase}-#{@information.version.downcase}-py3.13-linux-x86_64.egg PYTHONPATH
            CODE
            fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
        end

    end

end
