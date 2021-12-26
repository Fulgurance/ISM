# ISM

ISM or Ingenius Software Manager is an extremely advanced tool to build and manage a Linux system from scratch.
ISM is not only a tool to manage and update software. It facilitates the way to configure the system,
enable specific options for each packages, change Linux variables and settings... etc

## Usage

You can see main functionnalities when you just type ism in a terminal:
```
user $ ism
Ingenius System Manager
        -h      help    Display the help how to use ISM
        -v      version Display the ISM version
        -so     software        Install, configure and remove softwares
        -sy     system  Configure the system settings
        -se     settings        Configure ISM settings
```

```
user $ ism software
Install, configure and remove softwares
        -do     disableoption   Disable a specific software option
                                Need to be use like this:
                                ism software [softwarename] disableoption [optionname]
        -eo     enableoption    Enable a specific software option
                                Need to be use like this:
                                ism software [softwarename] enableoption [optionname]
        -i      install Install specific(s) software(s)
        -r      remove  Remove specific(s) software(s)
        -se     search  Search specific(s) software(s)
        -sy     synchronize     Synchronize the software database
        -u      update  Update specified software(s)
```

```
user $ ism system
Configure the system settings
        -sla    setlcall        Set the LC_ALL variable to setup the localization of specific country
```

```
user $ ism settings
Configure ISM settings
        -sa     setarchitecture Set the default target architecture for the compiler
        -sbo    setbuildoptions Set the default CPU flags for the compiler
        -smo    setmakeoptions  Set the default parallel make jobs number for the compiler
        -srp    setrootpath     Set the default root path where to install softwares
        -ssp    setsourcespath  Set the default path where ISM will download softwares sources
        -ssn    setsystemname   Set the name of the future installed system
        -stn    settargetname   Set the default machine target for the compiler
        -stp    settoolspath    Set the default path where ISM will install the tools
```

ISM is made to use all of the settings, for the compilation as well and pass all wanted arguments,
like GCC flags, number of parallels jobs, custom machine targets.

##About
It's actually highly experimental, and actually it's only possible to build the Cross-Toolchain of the LFS book.
Don't use that in a production environment, only in a virtual machine, except if you assume you are totally crazy (this is possible).
