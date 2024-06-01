module ISM
  module Option
    class Help < ISM::CommandLineOption
      def initialize
        super(ISM::Default::Option::Help::ShortText,
          ISM::Default::Option::Help::LongText,
          ISM::Default::Option::Help::Description,
          Array(ISM::CommandLineOption).new)
      end

      def start
        puts ISM::Default::CommandLine::Title
        Ism.options.each do |argument|
          puts "\t" + "#{argument.shortText.colorize(:white)}" +
               "\t" + "#{argument.longText.colorize(:white)}" +
               "\t" + "#{argument.description.colorize(:green)}"
        end
      end
    end
  end
end
