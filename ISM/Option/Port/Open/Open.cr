module ISM
  module Option
    class PortOpen < ISM::CommandLineOption
      def initialize
        super(ISM::Default::Option::PortOpen::ShortText,
          ISM::Default::Option::PortOpen::LongText,
          ISM::Default::Option::PortOpen::Description,
          Array(ISM::CommandLineOption).new)
      end

      def convertUrlToPort(url : String) : ISM::Port
        portName = url.lchop(url[0..url.rindex("/")])

        if portName[-4..-1] == ".git"
          portName = portName[0..-5]
        end

        ISM::Port.new(portName, url)
      end

      def start
        if ARGV.size == 2 + Ism.debugLevel
          showHelp
        else
          if !Ism.ranAsSuperUser && Ism.secureModeEnabled
            Ism.printNeedSuperUserAccessNotification
          else
            port = convertUrlToPort(ARGV[2 + Ism.debugLevel])

            if port.open
              Ism.printProcessNotification(ISM::Default::Option::PortOpen::OpenText + port.name)
            else
              Ism.printErrorNotification(ISM::Default::Option::PortOpen::OpenTextError1 + "#{port.name.colorize(:red)}" + ISM::Default::Option::PortOpen::OpenTextError2, nil)
            end
          end
        end
      end
    end
  end
end
