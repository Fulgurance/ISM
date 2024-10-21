module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            runPythonCommand(   arguments: "pip install '#{@information.name}==#{@information.version}'",
                                environment: {"PYTHONUSERBASE" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
        end

    end

end
