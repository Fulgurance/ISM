module ISM

    module Option

        class Version < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::Version::ShortText,
                        ISM::Default::Option::Version::LongText,
                        ISM::Default::Option::Version::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                puts ISM::Default::CommandLine::Title

                processResult = IO::Memory.new

                process = Process.run("git",args: [  "describe",
                                                        "--all"],
                                            output: processResult)
                currentVersion = processResult.to_s.strip
                currentVersion = currentVersion.lchop(currentVersion[0..currentVersion.rindex("/")])

                processResult.clear

                process = Process.run("git",args: [  "describe",
                                                        "--tags"],
                                            output: processResult)
                currentTag = processResult.to_s.strip

                processResult.clear

                snapshot = (currentVersion == currentTag)

                versionPrefix = snapshot ? "Version (snapshot): " : "Version (branch): "

                if !snapshot
                    process = Process.run("git",args: [ "rev-parse",
                                                        "HEAD"],
                                                output: processResult)

                    currentVersion = currentVersion+"-"+processResult.to_s.strip
                end

                version = versionPrefix + "#{currentVersion.colorize(:green)}"

                puts version
            end

        end
        
    end

end
