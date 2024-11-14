module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            fullName = "@ProgrammingLanguages-Main:Python"

            packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/python#{softwareMajorVersion(fullName)}.#{softwareMinorVersion(fullName)}/site-packages"

            runPipCommand(  arguments: "install --root-user-action --no-dependencies --target \"#{packagesPath}\" '#{@information.name}==#{@information.version}'")

            directoryContent(packagesPath, matchHidden: true).each do |filePath|

                if filePath == "#{packagesPath}/share"
                    destinationPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/share"

                    moveFile(   path:       filePath,
                                newPath:    destinationPath)
                end

                if filePath == "#{packagesPath}/bin"
                    destinationPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/bin"

                    moveFile(   path:       filePath,
                                newPath:    destinationPath)
                end

            end

        end

    end

end
