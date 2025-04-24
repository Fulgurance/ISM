module ISM

    class PythonPackageSoftware < ISM::SemiVirtualSoftware

        def preparePythonPackage(version = String.new)
            fullName = "@ProgrammingLanguages-Main:Python"

            packagesPath = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/python#{version}/site-packages"

            makeDirectory(packagesPath)

            runPipCommand(  arguments:  "install --root-user-action=ignore --no-dependencies --target \"#{packagesPath}\" '#{@information.name}==#{@information.version}'",
                            path: "/var/lib/ism",
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

            rescue exception
                ISM::Core::Error.show(  className: "PythonPackageSoftware",
                                        functionName: "preparePythonPackage",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
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

            rescue exception
                ISM::Core::Error.show(  className: "PythonPackageSoftware",
                                        functionName: "prepare",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)

        end

    end

end
