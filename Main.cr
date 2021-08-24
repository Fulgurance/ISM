require "./ISM/CommandLine"
require "./ISM/CommandLineOption"
require "./ISM/CommandLineSettings"
require "./ISM/CommandLineSystemSettings"
require "./ISM/SoftwareDependency"
require "./ISM/SoftwareInformation"
require "./ISM/SoftwareOption"
require "./ISM/Software"

require "./ISM/Default/Option/Help/Help"
require "./ISM/Default/Option/Settings/Settings"
require "./ISM/Default/Option/Software/Software"
require "./ISM/Default/Option/System/System"
require "./ISM/Default/Option/Version/Version"

require "./ISM/Default/Option/Software/Install/Install"

require "./ISM/Default/CommandLine"
require "./ISM/Default/CommandLineOption"
require "./ISM/Default/CommandLineSettings"
require "./ISM/Default/CommandLineSystemSettings"
require "./ISM/Default/Path"
require "./ISM/Default/Software"
require "./ISM/Default/SoftwareDependency"
require "./ISM/Default/SoftwareInformation"
require "./ISM/Default/SoftwareOption"

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
