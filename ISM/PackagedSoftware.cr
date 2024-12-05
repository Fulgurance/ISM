module ISM

    #EXPERIMENTAL
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

                moveFileNoChroot(entry,builtSoftwareDirectoryPathNoChroot)

            end
        end

    end

end
