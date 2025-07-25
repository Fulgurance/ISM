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

            makeDirectoryNoChroot(builtSoftwareDirectoryPathNoChroot)

            filesList = Dir.glob("#{mainWorkDirectoryPathNoChroot}/*", match: :dot_files)

            filesList.each do |entry|

                filename = "#{entry.gsub(mainWorkDirectoryPathNoChroot,"")}"

                moveFileNoChroot(entry,builtSoftwareDirectoryPathNoChroot+filename)

            end
        end

    end

end
