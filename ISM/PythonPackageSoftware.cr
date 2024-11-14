module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def prepare
            super

            fullName = "@ProgrammingLanguages-Main:Python"

            runPipCommand(  arguments: "install --no-dependencies --target \"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}\" '#{@information.name}==#{@information.version}'")

            packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/python#{softwareMajorVersion(fullName)}.#{softwareMinorVersion(fullName)}/site-packages"

            makeDirectory(packagesPath)

            directoryContent(["#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/**/*"], match: :dot_files).each do |filePath|

                if filePath != packagesPath && filePath != "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}bin"
                    moveFile(   path:       filePath,
                                newPath:    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/python#{softwareMajorVersion(fullName)}.#{softwareMinorVersion(fullName)}/site-packages/")
                end

            end

        end

    end

end
