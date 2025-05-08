module ISM

    class PackagedSoftware < ISM::Software

        def prepare
        end

        def configure
        end

        def build
        end

        def prepareInstallation
            super

            filesList = Dir.glob("#{mainWorkDirectoryPathNoChroot}/*", match: :dot_files)

            filesList.each do |entry|

                filename = "#{entry.gsub(mainWorkDirectoryPathNoChroot,"")}"

                moveFileNoChroot(entry,builtSoftwareDirectoryPathNoChroot+filename)

            end

            rescue exception
                ISM::Core::Error.show(  className: "PackagedSoftware",
                                        functionName: "prepareInstallation",
                                        errorTitle: "Execution failure",
                                        error: "Failed to execute the function",
                                        exception: exception)
        end

    end

end
