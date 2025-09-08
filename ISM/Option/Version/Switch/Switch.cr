module ISM

    module Option

        class Version

            class Switch < CommandLine::Option

                module Default

                    ShortText = "-sw"
                    LongText = "switch"
                    Description = "Switch ISM to another version"

                end

                def initialize
                    super(  Default::ShortText,
                            Default::LongText,
                            Default::Description)
                end

                def start
                    if ARGV.size == 2
                        showHelp
                    else
                        currentVersion = ARGV[2]

                        processResult = IO::Memory.new

                        process = Process.run(  "git describe --all",
                                                output: processResult,
                                                shell: true,
                                                chdir: "/"+Path::LibraryDirectory)
                        previousVersion = processResult.to_s.strip
                        previousVersion = previousVersion.lchop(previousVersion[0..previousVersion.rindex("/")])

                        process = Process.run(  "git switch --detach #{currentVersion}",
                                                shell: true,
                                                chdir: "/"+Path::LibraryDirectory)
                        if !process.success?
                            process = Process.run(  "git switch #{currentVersion}",
                                                    shell: true,
                                                    chdir: "/"+Path::LibraryDirectory)
                        end

                        process = Process.run(  "CRYSTAL_WORKERS=#{Ism.settings.systemMakeOptions[2..-1]} crystal build --release Main.cr -o #{Ism.settings.rootPath+Path::BinaryDirectory+Filename::IsmBinary}",
                                                shell: true,
                                                chdir: "/"+Path::LibraryDirectory)

                        process = Process.run(  "git update-ref -d /refs/heads/#{previousVersion}",
                                                shell: true,
                                                chdir: "/"+Path::LibraryDirectory)
                    end
                end

            end

        end
        
    end

end
