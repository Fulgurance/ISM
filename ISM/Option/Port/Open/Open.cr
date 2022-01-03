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
                if ARGV.size == 2
                    showHelp
                else
                    portName = ARGV[2].lchop(ARGV[2][0..ARGV[2].rindex("/")])

                    puts    "#{"* ".colorize(:green)}" +
                            ISM::Default::Option::PortOpen::OpenText +
                            portName

                    port = ISM::Port.new(portName,ARGV[2])
                    port.writePortFile(ISM::Default::Path::PortsDirectory+portName+".json")

                    Dir.mkdir(ISM::Default::Path::SoftwaresDirectory+port.name)
                    Process.run("git",  args: ["init"],
                                        chdir: ISM::Default::Path::SoftwaresDirectory+port.name)
                    Process.run("git",  args: [   "remote",
                                                "add",
                                                "origin",
                                                port.url],
                                        chdir: ISM::Default::Path::SoftwaresDirectory+port.name)
                end
            end

        end
        
    end

end
