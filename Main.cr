require "./ISM/Default/CommandLineOption"
require "./ISM/CommandLineOption"
require "./ISM/Default/CommandLine"
require "./ISM/CommandLine"
require "./ISM/Default/Message"
require "colorize"

options = [ISM::CommandLineOption.new("-h","--help","Show help")]

ism = ISM::CommandLine.new(options)
ism.start
