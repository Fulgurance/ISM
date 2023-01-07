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

                result = IO::Memory.new
                process = Process.run("git",args: [  "describe",
                                                        "--tags"],
                                            output: result)

                snapshot = process.success?

                versionPrefix = snapshot ? "Version (snapshot): " : "Version (branch): "
                versionName = result.to_s.strip

                if !snapshot
                    result.clear

                    process = Process.run("git",args: [ "branch",
                                                        "--show-current"],
                                                output: result)

                    versionName = result.to_s.strip
                    result.clear

                    process = Process.run("git",args: [ "rev-parse",
                                                        "HEAD"],
                                                output: result)

                    versionName = versionName+"-"+result.to_s.strip
                end

                version = versionPrefix + "#{versionName.colorize(:green)}"

                puts version
            end

        end
        
    end

end
