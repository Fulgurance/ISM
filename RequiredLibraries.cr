require "colorize"
require "file_utils"
require "json"
require "digest"
require "http/client"
require "system/group"
require "semantic_version"
require "socket"
require "./ISM/Core"
require "./ISM/CoreError"
require "./ISM/CoreSecurity"
require "./ISM/CommandLine"
require "./ISM/CommandLineSystemInformation"
require "./ISM/CommandLineOption"
require "./ISM/CommandLineSettings"
require "./ISM/CommandLinePortsSettings"
require "./ISM/CommandLineMirrorsSettings"
require "./ISM/KernelOption"
require "./ISM/NeededKernelOption"
require "./ISM/Mirror"
require "./ISM/Port"
require "./ISM/SoftwareSecurityDefaultConfiguration"
require "./ISM/SoftwareSecurityDescriptor"
require "./ISM/SoftwareSecurityMap"
require "./ISM/SoftwareDependency"
require "./ISM/SoftwareInformation"
require "./ISM/SoftwareOption"
require "./ISM/Software"
require "./ISM/TaskBuildingProcessError"
require "./ISM/KernelSoftware"
require "./ISM/PackagedSoftware"
require "./ISM/PackagedFirmware"
require "./ISM/SemiVirtualSoftware"
require "./ISM/PythonPackageSoftware"
require "./ISM/VirtualSoftware"
require "./ISM/ComponentSoftware"
require "./ISM/AvailableKernel"
require "./ISM/AvailableSoftware"
require "./ISM/FavouriteGroup"
require "./ISM/Default/Error"
require "./ISM/Default/Core"
require "./ISM/Default/CoreSecurity"
require "./ISM/Default/CommandLine"
require "./ISM/Default/CommandLineSystemInformation"
require "./ISM/Default/CommandLineSettings"
require "./ISM/Default/CommandLinePortsSettings"
require "./ISM/Default/CommandLineMirrorsSettings"
require "./ISM/Default/Filename"
require "./ISM/Default/KernelOption"
require "./ISM/Default/NeededKernelOption"
require "./ISM/Default/Mirror"
require "./ISM/Default/Path"
require "./ISM/Default/Port"
require "./ISM/Default/SoftwareSecurityDefaultConfiguration"
require "./ISM/Default/SoftwareSecurityDescriptor"
require "./ISM/Default/SoftwareSecurityMap"
require "./ISM/Default/Software"
require "./ISM/Default/SoftwareInformation"
require "./ISM/Default/FavouriteGroup"
require "./ISM/Default/Option/Help/Help"
require "./ISM/Default/Option/Settings/Settings"
require "./ISM/Default/Option/Settings/Show/Show"
require "./ISM/Default/Option/Settings/EnableInstallByChroot/EnableInstallByChroot"
require "./ISM/Default/Option/Settings/DisableInstallByChroot/DisableInstallByChroot"
require "./ISM/Default/Option/Settings/SetRootPath/SetRootPath"
require "./ISM/Default/Option/Settings/SetDefaultMirror/SetDefaultMirror"
require "./ISM/Default/Option/Settings/EnableBuildKernelOptionsAsModule/EnableBuildKernelOptionsAsModule"
require "./ISM/Default/Option/Settings/DisableBuildKernelOptionsAsModule/DisableBuildKernelOptionsAsModule"
require "./ISM/Default/Option/Settings/SetSystemTargetName/SetSystemTargetName"
require "./ISM/Default/Option/Settings/SetSystemArchitecture/SetSystemArchitecture"
require "./ISM/Default/Option/Settings/SetSystemMakeOptions/SetSystemMakeOptions"
require "./ISM/Default/Option/Settings/SetSystemBuildOptions/SetSystemBuildOptions"
require "./ISM/Default/Option/Settings/SetSystemName/SetSystemName"
require "./ISM/Default/Option/Settings/SetSystemFullName/SetSystemFullName"
require "./ISM/Default/Option/Settings/SetSystemId/SetSystemId"
require "./ISM/Default/Option/Settings/SetSystemRelease/SetSystemRelease"
require "./ISM/Default/Option/Settings/SetSystemCodeName/SetSystemCodeName"
require "./ISM/Default/Option/Settings/SetSystemDescription/SetSystemDescription"
require "./ISM/Default/Option/Settings/SetSystemVersion/SetSystemVersion"
require "./ISM/Default/Option/Settings/SetSystemVersionId/SetSystemVersionId"
require "./ISM/Default/Option/Settings/SetSystemAnsiColor/SetSystemAnsiColor"
require "./ISM/Default/Option/Settings/SetSystemCpeName/SetSystemCpeName"
require "./ISM/Default/Option/Settings/SetSystemHomeUrl/SetSystemHomeUrl"
require "./ISM/Default/Option/Settings/SetSystemSupportUrl/SetSystemSupportUrl"
require "./ISM/Default/Option/Settings/SetSystemBugReportUrl/SetSystemBugReportUrl"
require "./ISM/Default/Option/Settings/SetSystemPrivacyPolicyUrl/SetSystemPrivacyPolicyUrl"
require "./ISM/Default/Option/Settings/SetSystemBuildId/SetSystemBuildId"
require "./ISM/Default/Option/Settings/SetSystemVariant/SetSystemVariant"
require "./ISM/Default/Option/Settings/SetSystemVariantId/SetSystemVariantId"
require "./ISM/Default/Option/Settings/SetChrootTargetName/SetChrootTargetName"
require "./ISM/Default/Option/Settings/SetChrootArchitecture/SetChrootArchitecture"
require "./ISM/Default/Option/Settings/SetChrootMakeOptions/SetChrootMakeOptions"
require "./ISM/Default/Option/Settings/SetChrootBuildOptions/SetChrootBuildOptions"
require "./ISM/Default/Option/Settings/SetChrootName/SetChrootName"
require "./ISM/Default/Option/Settings/SetChrootFullName/SetChrootFullName"
require "./ISM/Default/Option/Settings/SetChrootId/SetChrootId"
require "./ISM/Default/Option/Settings/SetChrootRelease/SetChrootRelease"
require "./ISM/Default/Option/Settings/SetChrootCodeName/SetChrootCodeName"
require "./ISM/Default/Option/Settings/SetChrootDescription/SetChrootDescription"
require "./ISM/Default/Option/Settings/SetChrootVersion/SetChrootVersion"
require "./ISM/Default/Option/Settings/SetChrootVersionId/SetChrootVersionId"
require "./ISM/Default/Option/Settings/SetChrootAnsiColor/SetChrootAnsiColor"
require "./ISM/Default/Option/Settings/SetChrootCpeName/SetChrootCpeName"
require "./ISM/Default/Option/Settings/SetChrootHomeUrl/SetChrootHomeUrl"
require "./ISM/Default/Option/Settings/SetChrootSupportUrl/SetChrootSupportUrl"
require "./ISM/Default/Option/Settings/SetChrootBugReportUrl/SetChrootBugReportUrl"
require "./ISM/Default/Option/Settings/SetChrootPrivacyPolicyUrl/SetChrootPrivacyPolicyUrl"
require "./ISM/Default/Option/Settings/SetChrootBuildId/SetChrootBuildId"
require "./ISM/Default/Option/Settings/SetChrootVariant/SetChrootVariant"
require "./ISM/Default/Option/Settings/SetChrootVariantId/SetChrootVariantId"
require "./ISM/Default/Option/Software/Software"
require "./ISM/Default/Option/Software/AddPatch/AddPatch"
require "./ISM/Default/Option/Software/DeletePatch/DeletePatch"
require "./ISM/Default/Option/Software/SelectDependency/SelectDependency"
require "./ISM/Default/Option/Software/DisableOption/DisableOption"
require "./ISM/Default/Option/Software/EnableOption/EnableOption"
require "./ISM/Default/Option/Software/Install/Install"
require "./ISM/Default/Option/Software/Uninstall/Uninstall"
require "./ISM/Default/Option/Software/Clean/Clean"
require "./ISM/Default/Option/Software/Search/Search"
require "./ISM/Default/Option/Software/Synchronize/Synchronize"
require "./ISM/Default/Option/Software/Update/Update"
require "./ISM/Default/Option/System/System"
require "./ISM/Default/Option/Port/Port"
require "./ISM/Default/Option/Port/Open/Open"
require "./ISM/Default/Option/Port/Close/Close"
require "./ISM/Default/Option/Port/SetTargetVersion/SetTargetVersion"
require "./ISM/Default/Option/Port/Search/Search"
require "./ISM/Default/Option/Version/Version"
require "./ISM/Default/Option/Version/Show/Show"
require "./ISM/Default/Option/Version/Switch/Switch"
require "./ISM/Option/Help/Help"
require "./ISM/Option/Settings/Settings"
require "./ISM/Option/Settings/Show/Show"
require "./ISM/Option/Settings/EnableInstallByChroot/EnableInstallByChroot"
require "./ISM/Option/Settings/DisableInstallByChroot/DisableInstallByChroot"
require "./ISM/Option/Settings/SetRootPath/SetRootPath"
require "./ISM/Option/Settings/SetDefaultMirror/SetDefaultMirror"
require "./ISM/Option/Settings/EnableBuildKernelOptionsAsModule/EnableBuildKernelOptionsAsModule"
require "./ISM/Option/Settings/DisableBuildKernelOptionsAsModule/DisableBuildKernelOptionsAsModule"
require "./ISM/Option/Settings/SetSystemTargetName/SetSystemTargetName"
require "./ISM/Option/Settings/SetSystemArchitecture/SetSystemArchitecture"
require "./ISM/Option/Settings/SetSystemMakeOptions/SetSystemMakeOptions"
require "./ISM/Option/Settings/SetSystemBuildOptions/SetSystemBuildOptions"
require "./ISM/Option/Settings/SetSystemName/SetSystemName"
require "./ISM/Option/Settings/SetSystemFullName/SetSystemFullName"
require "./ISM/Option/Settings/SetSystemId/SetSystemId"
require "./ISM/Option/Settings/SetSystemRelease/SetSystemRelease"
require "./ISM/Option/Settings/SetSystemCodeName/SetSystemCodeName"
require "./ISM/Option/Settings/SetSystemDescription/SetSystemDescription"
require "./ISM/Option/Settings/SetSystemVersion/SetSystemVersion"
require "./ISM/Option/Settings/SetSystemVersionId/SetSystemVersionId"
require "./ISM/Option/Settings/SetSystemAnsiColor/SetSystemAnsiColor"
require "./ISM/Option/Settings/SetSystemCpeName/SetSystemCpeName"
require "./ISM/Option/Settings/SetSystemHomeUrl/SetSystemHomeUrl"
require "./ISM/Option/Settings/SetSystemSupportUrl/SetSystemSupportUrl"
require "./ISM/Option/Settings/SetSystemBugReportUrl/SetSystemBugReportUrl"
require "./ISM/Option/Settings/SetSystemPrivacyPolicyUrl/SetSystemPrivacyPolicyUrl"
require "./ISM/Option/Settings/SetSystemBuildId/SetSystemBuildId"
require "./ISM/Option/Settings/SetSystemVariant/SetSystemVariant"
require "./ISM/Option/Settings/SetSystemVariantId/SetSystemVariantId"
require "./ISM/Option/Settings/SetChrootTargetName/SetChrootTargetName"
require "./ISM/Option/Settings/SetChrootArchitecture/SetChrootArchitecture"
require "./ISM/Option/Settings/SetChrootMakeOptions/SetChrootMakeOptions"
require "./ISM/Option/Settings/SetChrootBuildOptions/SetChrootBuildOptions"
require "./ISM/Option/Settings/SetChrootName/SetChrootName"
require "./ISM/Option/Settings/SetChrootFullName/SetChrootFullName"
require "./ISM/Option/Settings/SetChrootId/SetChrootId"
require "./ISM/Option/Settings/SetChrootRelease/SetChrootRelease"
require "./ISM/Option/Settings/SetChrootCodeName/SetChrootCodeName"
require "./ISM/Option/Settings/SetChrootDescription/SetChrootDescription"
require "./ISM/Option/Settings/SetChrootVersion/SetChrootVersion"
require "./ISM/Option/Settings/SetChrootVersionId/SetChrootVersionId"
require "./ISM/Option/Settings/SetChrootAnsiColor/SetChrootAnsiColor"
require "./ISM/Option/Settings/SetChrootCpeName/SetChrootCpeName"
require "./ISM/Option/Settings/SetChrootHomeUrl/SetChrootHomeUrl"
require "./ISM/Option/Settings/SetChrootSupportUrl/SetChrootSupportUrl"
require "./ISM/Option/Settings/SetChrootBugReportUrl/SetChrootBugReportUrl"
require "./ISM/Option/Settings/SetChrootPrivacyPolicyUrl/SetChrootPrivacyPolicyUrl"
require "./ISM/Option/Settings/SetChrootBuildId/SetChrootBuildId"
require "./ISM/Option/Settings/SetChrootVariant/SetChrootVariant"
require "./ISM/Option/Settings/SetChrootVariantId/SetChrootVariantId"
require "./ISM/Option/Software/Software"
require "./ISM/Option/Software/AddPatch/AddPatch"
require "./ISM/Option/Software/DeletePatch/DeletePatch"
require "./ISM/Option/Software/SelectDependency/SelectDependency"
require "./ISM/Option/Software/DisableOption/DisableOption"
require "./ISM/Option/Software/EnableOption/EnableOption"
require "./ISM/Option/Software/Install/Install"
require "./ISM/Option/Software/Uninstall/Uninstall"
require "./ISM/Option/Software/Clean/Clean"
require "./ISM/Option/Software/Search/Search"
require "./ISM/Option/Software/Synchronize/Synchronize"
require "./ISM/Option/Software/Update/Update"
require "./ISM/Option/System/System"
require "./ISM/Option/Port/Port"
require "./ISM/Option/Port/Open/Open"
require "./ISM/Option/Port/Close/Close"
require "./ISM/Option/Port/SetTargetVersion/SetTargetVersion"
require "./ISM/Option/Port/Search/Search"
require "./ISM/Option/Version/Version"
require "./ISM/Option/Version/Show/Show"
require "./ISM/Option/Version/Switch/Switch"
