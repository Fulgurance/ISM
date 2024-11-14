module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            fullName = "@ProgrammingLanguages-Main:Python"

            packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/python#{softwareMajorVersion(fullName)}.#{softwareMinorVersion(fullName)}/site-packages"

            makeDirectory(packagesPath)

            runPipCommand(  arguments: "install --no-dependencies --target \"#{packagesPath}\" '#{@information.name}==#{@information.version}'")

            directoryContent(packagesPath, matchHidden: true).each do |filePath|

                if filePath.squeeze("/") == "#{packagesPath}/share".squeeze("/")
                    destinationPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr"

                    makeDirectory(destinationPath)

                    moveFile(   path:       filePath,
                                newPath:    destinationPath)
                end

                if filePath.squeeze("/") == "#{packagesPath}/bin".squeeze("/")
                    destinationPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr"

                    makeDirectory(destinationPath)

                    moveFile(   path:       filePath,
                                newPath:    destinationPath)
                end

            end

        end

    end

end
