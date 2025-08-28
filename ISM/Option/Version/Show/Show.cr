module ISM

    module Option

        class VersionShow < ISM::CommandLineOption

            module Default

                ShortText = "-s"
                LongText = "show"
                Description = "Show the current ISM version"

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def start
                puts CommandLine::Default::Title

                processResult = IO::Memory.new

                process = Process.run(  "git describe --all",
                                        output: processResult,
                                        shell: true,
                                        chdir: "/"+Path::LibraryDirectory)
                currentVersion = processResult.to_s.strip
                currentVersion = currentVersion.lchop(currentVersion[0..currentVersion.rindex("/")])

                processResult.clear

                process = Process.run(  "git describe --tags",
                                        output: processResult,
                                        shell: true,
                                        chdir: "/"+Path::LibraryDirectory)
                currentTag = processResult.to_s.strip

                processResult.clear

                snapshot = (currentVersion == currentTag)

                versionPrefix = snapshot ? "Version (snapshot): " : "Version (branch): "

                if !snapshot
                    process = Process.run(  "git rev-parse HEAD",
                                            output: processResult,
                                            shell: true,
                                            chdir: "/"+Path::LibraryDirectory)

                    currentVersion = currentVersion+"-"+processResult.to_s.strip
                end

                version = versionPrefix + "#{currentVersion.colorize(:green)}"

                puts version

            end

        end

    end

end
