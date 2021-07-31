require "./Message"
require "option_parser"
require "colorize"

parser = OptionParser.new do |parser|
  parser.banner = ISM::Default::Message::Banner

  parser.on(ISM::Default::Message::HelpShortOption,
            ISM::Default::Message::HelpOption,
            ISM::Default::Message::HelpOptionDescription) do
    puts parser
  end

  parser.on(ISM::Default::Message::VersionShortOption,
            ISM::Default::Message::VersionOption,
            ISM::Default::Message::VersionOptionDescription) do

  end

  parser.on(ISM::Default::Message::SoftwareOption,
            ISM::Default::Message::SoftwareOptionDescription) do
    puts parser
  end

  parser.on(ISM::Default::Message::SettingsOption,
            ISM::Default::Message::SettingsOptionDescription) do
    puts parser
  end

  parser.unknown_args do |args|

  end

  parser.invalid_option do |flag|
    STDERR.puts "Invalid Option: #{flag}"
    exit 1
  end

  parser.missing_option do |flag|
    STDERR.puts "Missing Option: #{flag}"
    exit 1
  end
end

puts parser
