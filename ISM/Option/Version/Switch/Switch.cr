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

                    process = Process.run("git",args: [ "describe",
                                                        "--all"],
                                                output: processResult,
                                                chdir: Ism.settings.rootPath+ISM::Default::Path::LibraryDirectory)
                    previousVersion = processResult.to_s.strip
                    previousVersion = previousVersion.lchop(previousVersion[0..previousVersion.rindex("/")])

                    process = Process.run("git",args: [ "switch",
                                                        "--detach",
                                                        currentVersion],
                                                chdir: Ism.settings.rootPath+ISM::Default::Path::LibraryDirectory)
                    if !process.success?
                        process = Process.run("git",args: [ "switch",
                                                            currentVersion],
                                                    chdir: Ism.settings.rootPath+ISM::Default::Path::LibraryDirectory)
                    end

                    process = Process.run("crystal",args: [ "build",
                                                            "Main.cr",
                                                            "-o",
                                                            Ism.settings.rootPath+ISM::Default::Path::BinaryDirectory+ISM::Default::Filename::IsmBinary],
                                                    chdir: Ism.settings.rootPath+ISM::Default::Path::LibraryDirectory)

                    process = Process.run("git",args: [ "update-ref",
                                                            "-d",
                                                            "/refs/heads/#{previousVersion}"],
                                                chdir: Ism.settings.rootPath+ISM::Default::Path::LibraryDirectory)
                end
            end

        end
        
    end

end
