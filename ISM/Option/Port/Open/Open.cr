module ISM

    module Option

        class PortOpen < ISM::CommandLineOption

            module Default

                ShortText = "-o"
                LongText = "open"
                Description = "Open the specified port"
                OpenText = "Opening port "
                OpenTextError1 = "Failed to open the port: "
                OpenTextError2 = ". The given port doesn't exist."

            end

            def initialize
                super(  Default::ShortText,
                        Default::LongText,
                        Default::Description)
            end

            def convertUrlToPort(url : String) : ISM::Port
                portName = url.lchop(url[0..url.rindex("/")])

                if portName[-4..-1] == ".git"
                    portName = portName[0..-5]
                end

                return ISM::Port.new(portName,url)
            end

            def start
                if ARGV.size == 2
                    showHelp
                else
                    port = convertUrlToPort(ARGV[2])

                    if port.open
                        Ism.printProcessNotification(Default::OpenText+"#{("@#{port.name}").colorize(Colorize::ColorRGB.new(255,100,100))}")
                    else
                        Ism.printErrorNotification(Default::OpenTextError1+"#{port.name.colorize(:red)}"+Default::OpenTextError2,nil)
                    end
                end
            end

        end
        
    end

end
