require "colorize"
require "file_utils"
require "json"
require "../ISM/Default/Path"
require "../ISM/Default/Filename"
require "../ISM/SoftwareOption"
require "../ISM/SoftwareDependency"
require "../ISM/SoftwareInformation"
require "../ISM/AvailableSoftware"
require "../ISM/Software"
require "../ISM/Version"
require "../ISM/CommandLineOption"
require "../ISM/Default/CommandLineSettings"
require "../ISM/CommandLineSettings"
require "../ISM/Default/CommandLineSystemSettings"
require "../ISM/CommandLineSystemSettings"
require "../ISM/Default/CommandLine"
require "../ISM/CommandLine"

Ism = ISM::CommandLine.new
Ism.loadSoftwareDatabase
Ism.loadSettingsFiles