module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            runPipCommand(  arguments: "install --no-dependencies --target \"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}\" '#{@information.name}==#{@information.version}'")

            packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/python#{softwareMajorVersion}.#{softwareMinorVersion}/site-packages"

            makeDirectory(packagesPath)

            Dir.glob(["#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/**/*"], match: :dot_files).each do |filePath|

                if filePath != packagesPath && filePath != "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}bin"
                    moveFile(,"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/python#{softwareMajorVersion}.#{softwareMinorVersion}/site-packages/*")
                end

            end

        end

    end

end
