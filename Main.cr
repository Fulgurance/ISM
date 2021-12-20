require "json"
require "colorize"
require "./ISM/CommandLine"
require "./ISM/CommandLineOption"
require "./ISM/CommandLineSettings"
require "./ISM/CommandLineSystemSettings"
require "./ISM/SoftwareDependency"
require "./ISM/SoftwareInformation"
require "./ISM/SoftwareOption"
require "./ISM/Software"
require "./ISM/AvailableSoftware"
require "./ISM/Version"
require "./ISM/Default/AvailableSoftware"
require "./ISM/Default/CommandLine"
require "./ISM/Default/CommandLineOption"
require "./ISM/Default/CommandLineSettings"
require "./ISM/Default/CommandLineSystemSettings"
require "./ISM/Default/Filename"
require "./ISM/Default/Path"
require "./ISM/Default/Software"
require "./ISM/Default/SoftwareDependency"
require "./ISM/Default/SoftwareInformation"
require "./ISM/Default/SoftwareOption"
require "./ISM/Default/Version"
require "./ISM/Default/Option/Help/Help"
require "./ISM/Default/Option/Settings/Settings"
require "./ISM/Default/Option/Settings/SetArchitecture/SetArchitecture"
require "./ISM/Default/Option/Settings/SetBuildOptions/SetBuildOptions"
require "./ISM/Default/Option/Settings/SetMakeOptions/SetMakeOptions"
require "./ISM/Default/Option/Settings/SetRootPath/SetRootPath"
require "./ISM/Default/Option/Settings/SetSourcesPath/SetSourcesPath"
require "./ISM/Default/Option/Settings/SetSystemName/SetSystemName"
require "./ISM/Default/Option/Settings/SetTargetName/SetTargetName"
require "./ISM/Default/Option/Settings/SetToolsPath/SetToolsPath"
require "./ISM/Default/Option/Software/Software"
require "./ISM/Default/Option/Software/DisableOption/DisableOption"
require "./ISM/Default/Option/Software/EnableOption/EnableOption"
require "./ISM/Default/Option/Software/Install/Install"
require "./ISM/Default/Option/Software/Remove/Remove"
require "./ISM/Default/Option/Software/Search/Search"
require "./ISM/Default/Option/Software/Synchronize/Synchronize"
require "./ISM/Default/Option/Software/Update/Update"
require "./ISM/Default/Option/System/System"
require "./ISM/Default/Option/System/SetLcAll/SetLcAll"
require "./ISM/Default/Option/Version/Version"
require "./ISM/Option/Help/Help"
require "./ISM/Option/Settings/Settings"
require "./ISM/Option/Settings/SetArchitecture/SetArchitecture"
require "./ISM/Option/Settings/SetBuildOptions/SetBuildOptions"
require "./ISM/Option/Settings/SetMakeOptions/SetMakeOptions"
require "./ISM/Option/Settings/SetRootPath/SetRootPath"
require "./ISM/Option/Settings/SetSourcesPath/SetSourcesPath"
require "./ISM/Option/Settings/SetSystemName/SetSystemName"
require "./ISM/Option/Settings/SetTargetName/SetTargetName"
require "./ISM/Option/Settings/SetToolsPath/SetToolsPath"
require "./ISM/Option/Software/Software"
require "./ISM/Option/Software/DisableOption/DisableOption"
require "./ISM/Option/Software/EnableOption/EnableOption"
require "./ISM/Option/Software/Install/Install"
require "./ISM/Option/Software/Remove/Remove"
require "./ISM/Option/Software/Search/Search"
require "./ISM/Option/Software/Synchronize/Synchronize"
require "./ISM/Option/Software/Update/Update"
require "./ISM/Option/System/System"
require "./ISM/Option/System/SetLcAll/SetLcAll"
require "./ISM/Option/Version/Version"

Options = [ ISM::Option::Help.new,
            ISM::Option::Version.new,
            ISM::Option::Software.new,
            ISM::Option::System.new,
            ISM::Option::Settings.new]

Ism = ISM::CommandLine.new(Options)
Ism.start