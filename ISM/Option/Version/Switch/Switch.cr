module ISM

    module Option

        class VersionSwitch < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::VersionSwitch::ShortText,
                        ISM::Default::Option::VersionSwitch::LongText,
                        ISM::Default::Option::VersionSwitch::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    currentVersion = ARGV[2+Ism.debugLevel]

                    processResult = IO::Memory.new

                    process = Process.run("git",args: [  "describe",
                                                        "--all"],
                                                output: processResult)
                    previousVersion = processResult.to_s.strip
                    previousVersion = previousVersion.lchop(previousVersion[0..previousVersion.rindex("/")])

                    process = Process.run("git",args: [ "switch",
                                                        "--detach",
                                                        currentVersion])
                    if !process.success?
                        process = Process.run("git",args: [ "switch",
                                                            currentVersion])
                    end

                    process = Process.run("crystal",args: [ "build",
                                                            "Main.cr",
                                                            "-o",
                                                            "ism"])

                    process = Process.run("git",args: [ "update-ref",
                                                            "-d",
                                                            "/refs/heads/#{previousVersion}"])
                end
            end

        end
        
    end

end
