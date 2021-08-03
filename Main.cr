
require "./ISM/Default/Option/*"
require "./ISM/Default/*"
require "./ISM/Option/*"
require "./ISM/*"
require "colorize"

options = [ISM::Option::Help]

ism = ISM::CommandLine.new(options)
ism.start
