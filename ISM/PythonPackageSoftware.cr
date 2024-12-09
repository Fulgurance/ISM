module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def preparePythonPackage(version = String.new)
            fullName = "@ProgrammingLanguages-Main:Python"

            packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/python#{version}/site-packages"

            makeDirectory(packagesPath)

            runPipCommand(  arguments:  "install --no-dependencies --target \"#{packagesPath}\" '#{@information.name}==#{@information.version}'",
                            version:    version)

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

        def prepare
            super

            prefix = "Python-"

            @information.options.each do |option|

                optionName = option.name

                if optionName.starts_with?(prefix) && option.active
                    preparePythonPackage(version: optionName[prefix.size..-1])
                end

            end

        end

    end

end
