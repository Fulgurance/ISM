module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            runPipCommand(  arguments: "install --no-dependencies --target \"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}\" '#{@information.name}==#{@information.version}'")
        end

    end

end
