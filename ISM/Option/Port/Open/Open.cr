module ISM

    module Option

        class PortOpen < ISM::CommandLineOption

            def initialize
                super(  ISM::Default::Option::PortOpen::ShortText,
                        ISM::Default::Option::PortOpen::LongText,
                        ISM::Default::Option::PortOpen::Description)
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
                        ISM::Core::Notification.processNotification(ISM::Default::Option::PortOpen::OpenText+"#{("@#{port.name}").colorize(Colorize::ColorRGB.new(255,100,100))}")
                    else
                        ISM::Core::Notification.errorNotification(ISM::Default::Option::PortOpen::OpenTextError1+"#{port.name.colorize(:red)}"+ISM::Default::Option::PortOpen::OpenTextError2,nil)
                    end
                end
            end

        end
        
    end

end
