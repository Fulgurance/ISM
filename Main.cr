require "./ISM/*"
require "./ISM/Default/*"
require "./ISM/Default/Option/Help/Help"
require "./ISM/Default/Option/Settings/Settings"
require "./ISM/Default/Option/Software/Software"
require "./ISM/Default/Option/System/System"
require "./ISM/Default/Option/Version/Version"
require "./ISM/Default/Option/Software/DisableOption/DisableOption"
require "./ISM/Default/Option/Software/EnableOption/EnableOption"
require "./ISM/Default/Option/Software/Install/Install"
require "./ISM/Default/Option/Software/Remove/Remove"
require "./ISM/Default/Option/Software/Search/Search"
require "./ISM/Default/Option/Software/Synchronize/Synchronize"
require "./ISM/Default/Option/Software/Update/Update"
require "./ISM/Option/Help/Help"
require "./ISM/Option/Settings/Settings"
require "./ISM/Option/Software/Software"
require "./ISM/Option/System/System"
require "./ISM/Option/Version/Version"
require "./ISM/Option/Software/DisableOption/DisableOption"
require "./ISM/Option/Software/EnableOption/EnableOption"
require "./ISM/Option/Software/Install/Install"
require "./ISM/Option/Software/Remove/Remove"
require "./ISM/Option/Software/Search/Search"
require "./ISM/Option/Software/Synchronize/Synchronize"
require "./ISM/Option/Software/Update/Update" 
require "http"
require "colorize"

Options = [ ISM::Option::Help.new,
            ISM::Option::Version.new,
            ISM::Option::Software.new,
            ISM::Option::System.new,
            ISM::Option::Settings.new]

Ism = ISM::CommandLine.new(Options)
Ism.start