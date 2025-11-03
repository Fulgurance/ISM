module ISM

    module Core

        def self.getLibraryDependenciesList(path : String) : Array(String)
            processResult = IO::Memory.new

            Process.run("ldd #{path}", shell: true, output: processResult)

            return processResult.to_s.split(/\s{2,}/,remove_empty: true)
        end

        def self.getMissingLibrariesList : Hash(String,Array(String))
            list = Hash(String,Array(String)).new

            binBinariesPath = Dir.glob("#{Ism.settings.rootPath}/usr/bin/**/*")
            sbinBinariesPath = Dir.glob("#{Ism.settings.rootPath}/usr/sbin/**/*")
            libexecBinariesPath = Dir.glob("#{Ism.settings.rootPath}/usr/libexec/**/*")
            localBinBinariesPath = Dir.glob("#{Ism.settings.rootPath}/usr/local/bin/**/*")
            localSbinBinariesPath = Dir.glob("#{Ism.settings.rootPath}/usr/local/sbin/**/*")
            localLibexecBinariesPath = Dir.glob("#{Ism.settings.rootPath}/usr/local/libexec/**/*")

            binariesPath =  binBinariesPath +
                            sbinBinariesPath +
                            libexecBinariesPath +
                            localBinBinariesPath +
                            localSbinBinariesPath +
                            localLibexecBinariesPath

            binariesPath.each_with_index do |binary, index|

                array = getLibraryDependenciesList(binary)
                filter = / => not found/

                array.each do |entry|
                    if entry.matches?(filter)
                        if list.has_key?(binary)
                            list[binary].push(entry.gsub(filter,""))
                        else
                            list[binary] = [entry.gsub(filter,"")]
                        end
                    end
                end
            end

            return list
        end

        def self.getSoftwareThatNeedRebuild : Array(ISM::SoftwareInformation)
            list = Array(ISM::SoftwareInformation).new

            missingLibrariesList = getMissingLibrariesList

            Ism.installedSoftwares.each do |software|

                missingLibrariesList.keys.each do |binary|

                    path = binary

                    if Ism.settings.rootPath != "/"
                        path = path.gsub(Ism.settings.rootPath[0..-2],"")
                    end

                    if software.installedFiles.includes?(path)
                        list.push(software)
                    end
                end

            end

            return list
        end

    end

end
