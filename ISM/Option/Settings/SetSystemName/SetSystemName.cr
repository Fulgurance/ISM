module ISM
  module Option
    class SettingsSetSystemName < ISM::CommandLineOption
      def initialize
        super(ISM::Default::Option::SettingsSetSystemName::ShortText,
          ISM::Default::Option::SettingsSetSystemName::LongText,
          ISM::Default::Option::SettingsSetSystemName::Description,
          Array(ISM::CommandLineOption).new)
      end

      def start
        if ARGV.size == 2 + Ism.debugLevel
          showHelp
        else
          if !Ism.ranAsSuperUser && Ism.secureModeEnabled
            Ism.printNeedSuperUserAccessNotification
          else
            Ism.settings.setSystemName(ARGV[2 + Ism.debugLevel])
            Ism.printProcessNotification(ISM::Default::Option::SettingsSetSystemName::SetText + ARGV[2 + Ism.debugLevel])
          end
        end
      end
    end
  end
end
