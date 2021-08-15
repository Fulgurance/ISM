require "./ISM/Default/Option/*"
require "./ISM/Default/*"
require "./ISM/*"
require "./ISM/Option/*"
require "http"
require "colorize"

options = [ ISM::Option::Help.new,
            ISM::Option::Version.new,
            ISM::Option::Software.new,
            ISM::Option::System.new,
            ISM::Option::Settings.new]

ism = ISM::CommandLine.new(options)
ism.start
