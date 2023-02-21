module ISM

    module Option

        class PortOpen < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortOpen::ShortText,
                        ISM::Default::Option::PortOpen::LongText,
                        ISM::Default::Option::PortOpen::Description,
                        Array(ISM::CommandLineOption).new)
            end

            def start
                if ARGV.size == 2+Ism.debugLevel
                    showHelp
                else
                    portName = ARGV[2+Ism.debugLevel].lchop(ARGV[2+Ism.debugLevel][0..ARGV[2+Ism.debugLevel].rindex("/")])

                    if portName[-4..-1] == ".git"
                        portName = portName[0..-5]
                    end

                    port = ISM::Port.new(portName,ARGV[2+Ism.debugLevel])

                    Dir.mkdir_p(Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)
                    Process.run("git",  args: ["init"],
                                        chdir: Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)
                    Process.run("git",  args: [ "remote",
                                                "add",
                                                "origin",
                                                port.url],
                                        chdir: Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)

                    process = Process.new("git",args: [ "ls-remote"],
                                                chdir: Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)

                    result = process.wait

                    if result.success?
                        port.writePortFile(Ism.settings.rootPath+ISM::Default::Path::PortsDirectory+portName+".json")

                        puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::PortOpen::OpenText +
                            portName
                    else
                        FileUtils.rm_r(Ism.settings.rootPath+ISM::Default::Path::SoftwaresDirectory+port.name)

                        puts    "#{"* ".colorize(:red)}" +
                            ISM::Default::Option::PortOpen::OpenTextError1 +
                            "#{portName.colorize(:red)}" +
                            ISM::Default::Option::PortOpen::OpenTextError2
                    end
                end
            end

        end
        
    end

end
