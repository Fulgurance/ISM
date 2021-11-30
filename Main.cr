require "./ISM/*"
require "./ISM/Default/*"
require "./ISM/Default/Option/Help/Help"
require "./ISM/Default/Option/Settings/Settings"
require "./ISM/Default/Option/Software/Software"
require "./ISM/Default/Option/System/System"
require "./ISM/Default/Option/Version/Version"
require "./ISM/Default/Option/Software/Install/Install"
require "./ISM/Option/Help/Help"
require "./ISM/Option/Settings/Settings"
require "./ISM/Option/Software/Software"
require "./ISM/Option/System/System"
require "./ISM/Option/Version/Version"
require "./ISM/Option/Software/Install/Install"

require "http"
require "colorize"

Options = [ ISM::Option::Help.new,
            ISM::Option::Version.new,
            ISM::Option::Software.new,
            ISM::Option::System.new,
            ISM::Option::Settings.new]

Ism = ISM::CommandLine.new(Options)
Ism.start
