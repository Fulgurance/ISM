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

                versionName = String.new

                result = IO::Memory.new
                process = Process.run("git",   args: [  "describe",
                                                        "--tags"],
                                                            output: result)

                snapshot = process.success?

                if !snapshot
                    result.clear
                    process = Process.run("git",args: [ "branch",
                                                        "--show-current"],
                                                            output: result)
                end

                versionPrefix = snapshot ? "Version (snapshot): " : "Version (branch): "
                versionName = versionPrefix + "#{result.to_s.colorize(:green)}"

                puts versionName
            end

        end
        
    end

end
